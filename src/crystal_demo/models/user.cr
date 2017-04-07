module CrystalDemo
  struct User
    @id : (Int32 | Nil)
    @md5sum : (String | Nil)

    property :id, :md5sum

    def self.sign_in(id : String, md5sum : String) : UserHash
      user_hash = UserHash.new

      name = CrystalDemo::Repo.get_by(CrystalDemo::Name, id: id, md5sum: md5sum)

      if name
        user_hash["id"] = name.id.as(Int32)
        user_hash["md5sum"] = name.md5sum
      else
        user_hash["error"] = true
      end

      return user_hash
    end

    def self.load_user(user : Hash) : UserHash
      user_hash = UserHash.new
      id = user["id"].to_s
      # id = (user["id"] || user["email"]).to_s

      name = CrystalDemo::Repo.get_by(CrystalDemo::Name, id: id)

      if name
        user_hash["id"] = id.to_i
        user_hash["md5sum"] = name.md5sum
        user_hash["name"] = name.name
      end

      user_hash
    end
  end
end
