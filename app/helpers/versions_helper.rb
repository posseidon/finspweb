module VersionsHelper

  def schema(model)
    case model
    when 'Administrative Units'
      (Administrativeunit.new.attributes.keys - ["id", "geom"]).to_json
    when 'Cadastral Parcels'
      (Cadastralparcel.new.attributes.keys - ["id", "geom"]).to_json
    when 'Geographical Names'
      (Geographicalname.new.attributes.keys - ["id", "geom"]).to_json
    else
      raise NotImplementedError
    end
  end

  def rendering(identifier)
    case identifier
    when 'Geographical Names'
      return 'gn'
    when 'Cadastral Parcels'
      return 'cp'
    when 'Administrative Units'
      return 'au'
    else
      raise NotImplementedError
    end
  end

  def display_status(status)
    if status
      raw("<i class='icon-ok-sign'></i>")
    else
      raw("<i class='icon-remove-sign'></i>")
    end
  end

  def mappings_of(type)
    current_user.mappings.where(mapping_type: type)
  end

end
