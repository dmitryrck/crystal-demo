module CrystalDemo
  class Name < Crecto::Model
    schema "name" do
      field :name, String
      field :md5sum, String

      has_many :cast_infos, CastInfo, foreign_key: :person_id

      created_at_field nil
      updated_at_field nil

      validate_required [:name, :md5sum]
      validate_length :name, min: 3
    end

    def from_json(json : String)
      parsed = JSON.parse(json)
      keys = parsed.as_h.keys

      self.tap do |name|
        if keys.includes?("name")
          name.name = parsed["name"].to_s
        end

        if keys.includes?("md5sum")
          name.md5sum = parsed["md5sum"].to_s
        end
      end
    end

    def to_hash : Hash
      { "id" => id, "name" => name, "md5sum" => md5sum }
    end
  end
end
