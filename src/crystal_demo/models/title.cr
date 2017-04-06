module CrystalDemo
  class Title < Crecto::Model
    schema "title" do
      field :title, String
      field :kind_id, Int32
      field :production_year, Int32

      belongs_to :kind_type, KindType, foreign_key: :kind_id
    end

    def to_hash : Hash
      { "id" => id, "title" => title, "kind_type" => kind_type_hash }
    end

    private def kind_type_hash
      if kind_type
        kind_type.as(KindType).to_hash
      end
    end
  end
end
