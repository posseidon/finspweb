class Administrativeunit < ActiveRecord::Base
  attr_accessible :identifier, :name, :code, :natcode, :levelname, :level, :geom

  def set_attributes(record, mappings, projection)
    self.identifier = record.attributes[mappings['identifier']]
    self.name = record.attributes[mappings['name']]
    self.code = record.attributes[mappings['code']]
    self.natcode = record.attributes[mappings['natcode']]
    self.levelname = record.attributes[mappings['levelname']]

    self.geom = ConfigHandler.transform_geometry(projection, record.geometry, 4258)
  end
end
