class Geographicalname < ActiveRecord::Base
  attr_accessible :name, :language, :type_of_name, :tipus_nev, :sourceofname

  def set_attributes(record, mappings)
    self.name          = attributes_of(record, mappings['name'])
    self.language      = attributes_of(record, mappings['language'])
    self.type_of_name  = attributes_of(record, mappings['type_of_name'])
    self.tipus_nev     = attributes_of(record, mappings['tipus_nev'])
    self.sourceofname  = attributes_of(record, mappings['sourceofname'])

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
