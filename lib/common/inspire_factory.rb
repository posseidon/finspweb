#
# Creating objects and identifiers related to Inspire objects.
#
class InspireFactory
  OBJECTS = {
        'au' => {
          'creation'   => Administrativeunit.new,
          'table_name' => Administrativeunit.table_name,
          'identifier' => 'Administrative Units'
        },
        'cp' => {
          'creation'   => Cadastralparcel.new,
          'table_name' => Cadastralparcel.table_name,
          'identifier' => 'Cadastral Parcels'
        }
      }

  def self.create(type)
    return OBJECTS[type]['creation']
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
    else
      raise NotImplementedError
    end
  end


end