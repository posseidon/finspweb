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
    SuckerPunch::Queue[:extract_queue].async.perform(params[:id])
  end

  def transform
    shapeid = params[:shapeid]
    maplist = params[:map_list]
    object_type = params[:type]
    unless Shapefile.valid_for_processing(params[:type])
      SuckerPunch::Queue[:processing_queue].async.perform(shapeid, maplist, object_type)
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

    SuckerPunch::Queue[:deactivate_queue].async.perform(archive_path, compress, schema, shapeid)
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


end
