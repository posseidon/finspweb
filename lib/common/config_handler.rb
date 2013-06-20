#
# Static Class
# Description: Dump command, get application configuration data
#   Dump filename generator
#   Constant SRID: 4258 projection
#   Transform projection of geometry
#
class ConfigHandler
  EPSG_4258 = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs "
  EPSG_23700 = "+proj=somerc +lat_0=47.14439372222222 +lon_0=19.04857177777778 +k_0=0.99993 +x_0=650000 +y_0=200000 +ellps=GRS67 +units=m +no_defs "

  def self.dump_command
    "pg_dump -U {{user}} -w {{compress}} -b -a -h {{hostname}} -t {{tablename}} {{databasename}} -f {{output_directory}}/{{filename}}"
  end

  def self.ogr2ogr_command
    "ogr2ogr -f 'ESRI Shapefile' -s_srs EPSG:{{src_proj}} -t_srs EPSG:4258 {{new_file}} {{src_file}}"
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

end
