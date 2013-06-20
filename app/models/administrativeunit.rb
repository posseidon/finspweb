class Administrativeunit < ActiveRecord::Base
  attr_accessible :identifier, :name, :code, :natcode, :levelname, :level, :geom

  def set_attributes(record, mappings)
    self.identifier = attributes_of(record, mappings['identifier'])
    self.name       = attributes_of(record, mappings['name'])
    self.code       = attributes_of(record, mappings['code'])
    self.natcode    = attributes_of(record, mappings['natcode'])
    self.levelname  = attributes_of(record, mappings['levelname'])

    parser = RGeo::WKRep::WKTParser.new(nil, :default_srid => 4258)
    self.geom       = parser.parse(record.geometry.as_text)
  end

  private
  def attributes_of(record, by_mapping)
    values = []
    by_mapping.split(",").each do |value|
      values.push(record.attributes[value])
    end
    return values.join("-")
  end

end
