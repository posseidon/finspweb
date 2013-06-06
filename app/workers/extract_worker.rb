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
    dirname = File.dirname(shapefile.shapefile.path)
    unzip_file(shapefile.shapefile.path, dirname)
    shapefile.update_attributes!(:condition => "Extracted", :note => metadata(shapefile.shapefile.path))
  end

  def unzip_file (file, destination)
    Zip::ZipFile.open(file) { |zip_file|
     zip_file.each { |f|
       f_path=File.join(destination, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
     }
    }
  end

  def metadata(shapefile_path)
    layer = Layer.new
    dirname = File.dirname(shapefile_path)
    Dir.glob("#{dirname}/*.shp").each do |shp_file|
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