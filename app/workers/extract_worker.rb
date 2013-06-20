require 'zip/zip'
require 'fileutils'

#
#  ExtractWorker
#  description:
#    Extracting Zip file containing multiple shapefiles
#
class ExtractWorker
  include SuckerPunch::Worker

  def perform(id)
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

  private

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
end