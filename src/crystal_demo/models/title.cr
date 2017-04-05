module CrystalDemo
  class Title < Crecto::Model
    schema "title" do
      field :title, String
      field :kind_id, Int32
      field :production_year, Int32
    end
  end
end
