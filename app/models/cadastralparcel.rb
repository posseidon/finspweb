class Cadastralparcel < ActiveRecord::Base
  attr_accessible :identifier, :localid, :area, :label, :natref, :geom

  def set_attributes(record, mappings, projection)
    self.identifier = record.attributes[mappings['identifier']]
    self.localid = record.attributes[mappings['localid']]
    self.area = record.attributes[mappings['are']]
    self.label = record.attributes[mappings['label']]
    self.natref = record.attributes[mappings['natref']]

    self.geom = ConfigHandler.transform_geometry(projection, record.geometry, 4258)
  end
end
