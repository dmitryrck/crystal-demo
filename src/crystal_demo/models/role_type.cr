module CrystalDemo
  class RoleType < Crecto::Model
    schema "role_type" do
      field :role, String

      has_many :cast_infos, CastInfo, foreign_key: :role_id

      created_at_field nil
      updated_at_field nil
    end
  end
end
