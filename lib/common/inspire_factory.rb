#
# Creating objects and identifiers related to Inspire objects.
#
class InspireFactory
  OBJECTS = {
        'au' => {
          'table_name' => Administrativeunit.table_name,
          'identifier' => 'Administrative Units'
        },
        'cp' => {
          'table_name' => Cadastralparcel.table_name,
          'identifier' => 'Cadastral Parcels'
        },
        'gn' => {
          'table_name' => Geographicalname.table_name,
          'identifier' => 'Geographical Names'
        }
      }

  def self.create(type)
    case type
    when 'au'
      return Administrativeunit.new
    when 'cp'
      return Cadastralparcel.new
    when 'gn'
      return Geographicalname.new
    else
      return nil
    end
  end

  def self.table_name(type)
    return OBJECTS[type]['table_name']
  end

  def self.identifier(type)
    return OBJECTS[type]['identifier']
  end


  def self.destroy_all(type)
    case type
    when 'au'
      Administrativeunit.delete_all
    when 'cp'
      Cadastralparcel.delete_all
    when 'gn'
      Geographicalname.delete_all
    else
      raise NotImplementedError
    end
  end


end