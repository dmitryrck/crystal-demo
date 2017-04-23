module CrystalDemo
  class Title < Crecto::Model
    schema "title" do
      field :title, String
      field :kind_id, Int32
      field :production_year, Int32

      belongs_to :kind_type, KindType, foreign_key: :kind_id

      has_many :cast_infos, CastInfo, foreign_key: :movie_id

      created_at_field nil
      updated_at_field nil

      # Only title and kind_id are required (aka `not null`) in database.
      validate_required [:title, :production_year]
      validate_length :title, min: 3
    end

    def from_json(json : String)
      parsed = JSON.parse(json)
      keys = parsed.as_h.keys

      self.tap do |title|
        if keys.includes?("title")
          title.title = parsed["title"].to_s
        end

        if keys.includes?("production_year")
          title.production_year = parsed["production_year"].as_i
        end

        if keys.includes?("kind_id")
          title.kind_id = parsed["kind_id"].as_i
        end
      end
    end

    def to_hash : Hash
      { "id" => id, "title" => title, "production_year" => production_year, "kind_type" => kind_type_hash }
    end

    private def kind_type_hash
      if kind_type
        kind_type.as(KindType).to_hash
      end
    end
  end
end
