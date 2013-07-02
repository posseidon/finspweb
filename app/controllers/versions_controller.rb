require 'zip/zip'
require 'fileutils'
#
# Description:
#   Managing Versions: create
#   Managing Shapefile processing:
#     - Extract, Processes and Archive (also Deactivate)
#
class VersionsController < ApplicationController
  before_filter :authenticate_user!

  # GET /versions
  def index
    @all_versions = Version.includes(:shapefiles).order(:name).limit(1)
    unless @all_versions.empty?
      @versions = Version.active
    else
      render :empty
    end
  end

  def search
    if params[:search] == "all"
      @versions = Version.includes(:shapefiles).all
    else
      @versions = Version.includes(:shapefiles).search_by_description(params[:search])
    end
  end

  # GET /versions/new
  def new
    @version = current_user.versions.new
    @version.generate_shapefiles
  end

  # POST /versions
  def create
    @version = Version.new(params[:version])
    if @version.save
      flash[:notice] = 'Version was successfully created.'
      redirect_to(@version)
    else
      render :new
    end
  end


  # GET /versions/1
  def show
    id = params[:id]
    @version = Version.includes(:shapefiles).find(id)
  rescue => exception
    @message = "Version not found"
    render "error", :locals => {:message => @message}
  end

  def destroy
    Version.destroy(params[:id])
    redirect_to :action => 'index'
  rescue => exception
    Rails.logger.info("#{exception}")
  end

  def extract
    perform_extract(params[:id])
    #SuckerPunch::Queue[:extract_queue].async.perform(params[:id])
  end

  def transform
    shapeid = params[:shapeid]
    maplist = params[:map_list]
    object_type = params[:type]
    unless Shapefile.valid_for_processing(params[:type])
      perform_transform(shapeid, maplist, object_type)
      #SuckerPunch::Queue[:processing_queue].async.perform(shapeid, maplist, object_type)
    else
      @error = true
      @active_shp = Shapefile.where(:identifier => params[:type], :condition => 'Processed').first
    end
  end

  def deactivate
    location = params[:location]
    shapeid = params[:shapeid]
    schema = params[:schema]

    default_path = "#{ConfigHandler.app_config('archive_folder')}"
    archive_path = params['default_path'].nil? ? location : default_path
    compress = params['compress'] == nil ? false : true

    #SuckerPunch::Queue[:deactivate_queue].async.perform(archive_path, compress, schema, shapeid)
    perform_deactivate(archive_path, compress, schema, shapeid)
  rescue => exception
      # TODO: Log: Error on params[archive_path] does not exists
    puts exception
  end

  def save_mapping
    @mapping = current_user.mappings.create(:name => params[:name], :mapping_type => params[:mapping_type], :data => params[:data])
    @shapefile = Shapefile.find(params[:shapefile])
  end

  def folder_exists
    @exists = Dir.exist?(params["location"])
    puts @exists
  end

  def download_archive
    send_file(params[:path])
  end


  private

  def perform_extract(id)
    shapefile = Shapefile.find(id)
    begin
      dirname = File.dirname(shapefile.shapefile.path)
      unzip(shapefile.shapefile.path, dirname)
      transform_projection_of(dirname, shapefile.projection)
      shapefile.update_attributes!(:condition => "Extracted", :note => metadata(shapefile.shapefile.path))
    rescue => exception
      shapefile.update_attributes!(:faults => "#{exception}")
      Rails.logger.info("#{exception}")
    end
  end

  #
  # Unzipping .zip file
  #
  def unzip(file, to_destination)
    Zip::ZipFile.open(file) { |zip_file|
     zip_file.each { |f|
       f_path=File.join(to_destination, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
     }
    }
  end

  #
  # Transform Projection of shapefiles in path
  # Note: Transformed files will be saved as *_conv.shp
  #
  def transform_projection_of(shapefiles_path, with_projection)
    converted_path = "#{shapefiles_path}/converted"
    Dir.mkdir(converted_path)
    Dir.glob("#{shapefiles_path}/*.shp").each do |shapefile|
      command = ConfigHandler.ogr2ogr_command
      command.gsub!("{{src_proj}}", "#{with_projection}")
      command.gsub!("{{src_file}}", shapefile)
      command.gsub!("{{new_file}}", "#{converted_path}/#{File.basename(shapefile)}")
      system(command)
    end
  end

  #
  # Save metadata of shapefiles into notes column in Shapefiles table.
  #
  def metadata(shapefile_path)
    layer = Layer.new
    dirname = File.dirname(shapefile_path)
    Dir.glob("#{dirname}/converted/*.shp").each do |shp_file|
      RGeo::Shapefile::Reader.open(shp_file) do |file|
        layer.add_file(shp_file, file.num_records)
        record = file.get(0)
        unless layer.attributes.nil?
          layer.attributes = record.keys().to_json
        end
      end
    end
    layer.to_json
  end

  def perform_transform(shape_id, map_list, object_type)
    mappings = Hash[*JSON.parse(map_list)]
    shapefile = Shapefile.find(shape_id)

    features = 0
    JSON.parse(JSON.parse(shapefile.note)['files']).each do |file|
      store_shapefile(file['file'], mappings, object_type)
      features += file['size']
    end

    shapefile.update_condition('Processed', features)
  end

  def store_shapefile(filename, mappings, object_type)
    RGeo::Shapefile::Reader.open(filename) do |shp_file|
      shp_file.each do |record|
        object = InspireFactory.create(object_type)
        object.set_attributes(record, mappings)
        object.save
      end
    end
  end

  def perform_deactivate(archive_path, use_compression, schema, shapeid)
    default_parameters = setup_parameters(archive_path, use_compression, schema, shapeid)

    command = gsub_dump_command(default_parameters)
    system(command)

    shapefile = Shapefile.find(shapeid)
    shapefile.condition = 'Archived'
    shapefile.archive_path = "#{archive_path}/#{default_parameters['{{filename}}']}"
    shapefile.save!

    version = shapefile.version
    version.active = false
    version.archived = true
    version.save!

    InspireFactory.destroy_all(schema)
  end

  def setup_parameters(archive_path, use_compression, schema, shapeid)
    parameters = {
      "{{user}}" => ConfigHandler.db_config('username'),
      "{{databasename}}" => ConfigHandler.db_config('database'),
      "{{output_directory}}" => archive_path,
      "{{hostname}}" => ConfigHandler.db_config('host'),
      "{{tablename}}" => InspireFactory.table_name(schema),
      "{{compress}}" => use_compression == true ? "-Ft" : " "
    }
    if use_compression
      parameters["{{filename}}"] = ConfigHandler.generate_file_name(schema, shapeid, true)
    else
      parameters["{{filename}}"] = ConfigHandler.generate_file_name(schema, shapeid, false)
    end
    return parameters
  end

  def gsub_dump_command(parameters)
    command = ConfigHandler.dump_command
    parameters.each do |key, value|
      command.gsub!(key, value)
    end
    return command
  end

end
