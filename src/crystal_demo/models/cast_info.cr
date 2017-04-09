module CrystalDemo
  class CastInfo < Crecto::Model
    schema "cast_info" do
      field :note, String

      belongs_to :name, Name, foreign_key: :person_id
      belongs_to :title, Title, foreign_key: :movie_id
      belongs_to :role, RoleType, foreign_key: :role_id

      created_at_field nil
      updated_at_field nil
    end
  end
end
