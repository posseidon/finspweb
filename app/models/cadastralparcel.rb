class Cadastralparcel < ActiveRecord::Base
  attr_accessible :identifier, :localid, :area, :label, :natref, :geom

  def set_attributes(record, mappings, projection)
    self.identifier = attributes_of(record, mappings['identifier'])
    self.localid    = attributes_of(record, mappings['localid'])
    self.area       = attributes_of(record, mappings['area'])
    self.label      = attributes_of(record, mappings['label'])
    self.natref     = attributes_of(record, mappings['natref'])

    self.geom = ConfigHandler.transform_geometry(projection, record.geometry, 4258)
  end

  private
  def attributes_of(record, mapping)
    values = []
    mapping.split(",").each do |value|
      values.push(record.attributes[value])
    end
    return values.join("-")
  end
end
