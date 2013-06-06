#
# Store each shapefile content into Inspire tables.
#
class ProcessingWorker
  include SuckerPunch::Worker

  def perform(shape_id, map_list, object_type)
    mappings = Hash[*JSON.parse(map_list)]
    shapefile = Shapefile.find(shape_id)

    features = 0
    JSON.parse(shapefile.note)['files'].each do |file|
      store_shapefile(file['file'], mappings, shapefile.projection, object_type)
      features += file['size']
    end

    shapefile.update_condition('Processed', features)
  end

  private
  def store_shapefile(filename, mappings, projection, object_type)
    RGeo::Shapefile::Reader.open(filename) do |shp_file|
      shp_file.each do |record|
        object = InspireFactory.create(object_type)
        object.set_attributes(record, mappings, projection)
        object.save!
      end
    end
  end
end