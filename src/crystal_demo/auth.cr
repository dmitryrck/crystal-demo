module CrystalDemo::Auth
  def auth(headers : HTTP::Headers)
    auth = headers["Authorization"]?

    return unless auth

    token = auth.split(":")[-1]

    return_if_valid_user(query(token))
  end

  private def query(token)
    CrystalDemo::Repo.get_by(CrystalDemo::Name, md5sum: token)
  end

  private def return_if_valid_user(user : CrystalDemo::Name) : CrystalDemo::Name
    user
  end

  private def return_if_valid_user(user : Nil) : Bool
    false
  end
end
