require 'json'

#
#  Description:
#    Representing a shapefile in Layer terminology
#
class Layer
  attr_accessor :attributes

  def initialize()
    @files = []
    @attributes = ''
  end

  def add_file(name, size)
    @files.push({:file => name.gsub('dbf','shp'), :size => size})
  end

  def to_json
    {
      "files"  => @files.to_json,
      "schema" => @attributes
    }.to_json
  end

  #
  # DBF Column schema definition
  # format: 'column_name, :data_type'
  #
  def Layer.extract_attribute(dbf_column_schema)
    data = dbf_column_schema.split(",")
    attr_name = data[0]
    attr_type = data[1].gsub(/[:]/,'').strip
    return {attr_name => attr_type}
  end

end