#
# Static Class
# Description: Dump command, get application configuration data
#   Dump filename generator
#   Constant SRID: 4258 projection
#   Transform projection of geometry
#
class ConfigHandler
  EPSG_4258 = "+proj=longlat +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +no_defs"

  def self.dump_command
    "pg_dump -U {{user}} -w {{compress}} -b -a -h {{hostname}} -t {{tablename}} {{databasename}} -f {{output_directory}}/{{filename}}"
  end

  def self.app_config(variable)
    APP_CONFIG[variable]
  end

  def self.db_config(variable)
    Rails.configuration.database_configuration[Rails.env][variable]
  end

  def self.generate_file_name(schema, shape_id, compacted)
    time = Time.now.strftime('%Y%m%d-%H%M')
    basename = "#{schema}-#{shape_id}-#{time}"
    filename = compacted == true ? "#{basename}.tar" : "#{basename}.sql"
  end

  def self.transform_geometry(source_srid, source_geometry, destination_srid)
    unless source_srid == destination_srid
      src_proj  = RGeo::Geographic.spherical_factory(:srid => source_srid)
      dest_proj = RGeo::Geos.factory(:proj4 => self.EPSG_4258, :srid => destination_srid)
      return RGeo::CoordSys::Proj4.transform(src_proj.proj4, source_geometry, dest_proj.proj4, dest_proj)
    else
      return source_geometry
    end
  end

end
