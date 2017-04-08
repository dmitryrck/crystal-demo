module CrystalDemo
  class Name < Crecto::Model
    schema "name" do
      field :name, String
      field :md5sum, String

      has_many :cast_infos, CastInfo, foreign_key: :person_id
    end
  end
end
