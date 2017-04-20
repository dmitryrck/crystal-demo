module CrystalDemo
  class KindType < Crecto::Model
    schema "kind_type" do
      field :kind, String

      has_many :titles, Title, foreign_key: :kind_id

      created_at_field nil
      updated_at_field nil
    end

    def to_hash : Hash
      { "id" => id, "name" =>  kind }
    end
  end
end
