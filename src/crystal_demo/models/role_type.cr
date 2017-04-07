module CrystalDemo
  class RoleType < Crecto::Model
    schema "role_type" do
      field :role, String

      has_many :cast_infos, CastInfo, foreign_key: :role_id
    end
  end
end
