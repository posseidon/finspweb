class DeactivateWorker
  include SuckerPunch::Worker

  def perform(archive_path, use_compression, schema, shapeid)
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

  private
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