class Cadastralparcel < ActiveRecord::Base
  attr_accessible :identifier, :localid, :area, :label, :natref, :geom

  def set_attributes(record, mappings)
    self.identifier = attributes_of(record, mappings['identifier'])
    self.localid    = attributes_of(record, mappings['localid'])
    self.area       = attributes_of(record, mappings['area'])
    self.label      = attributes_of(record, mappings['label'])
    self.natref     = attributes_of(record, mappings['natref'])

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
