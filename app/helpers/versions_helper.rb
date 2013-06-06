module VersionsHelper

  def schema(model)
    case model
    when 'AU'
      (Administrativeunit.new.attributes.keys - ["id", "geom"]).to_json
    when 'CP'
      (Cadastralparcel.new.attributes.keys - ["id", "geom"]).to_json
    when 'GN'
      raise NotImplementedError
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

end
