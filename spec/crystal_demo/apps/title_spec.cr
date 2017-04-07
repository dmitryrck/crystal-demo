require "../../spec_helper"

describe CrystalDemo::TitleApp do
  context "when there is no title" do
    it "should return an empty array" do
      get "/titles"

      response.body.should eq("[]")
    end
  end

  context "when there is a title" do
    it "should return all the titles" do
      kind_type = CrystalDemo::KindType.new
      kind_type.kind = "episode"
      kind_type = CrystalDemo::KindType.changeset(kind_type)
      kind_type = CrystalDemo::Repo.insert(kind_type)

      title = CrystalDemo::Title.new
      title.title = "Passengers"
      title.kind_id = kind_type.instance.id
      title.production_year = 2016

      changeset = CrystalDemo::Title.changeset(title)
      CrystalDemo::Repo.insert(changeset)

      get "/titles"

      JSON.parse(response.body).map { |movie| movie["title"] }.should contain("Passengers")
    end

    it "should include kind_type" do
      kind_type = CrystalDemo::KindType.new
      kind_type.kind = "episode"
      kind_type = CrystalDemo::KindType.changeset(kind_type)
      kind_type = CrystalDemo::Repo.insert(kind_type)

      title = CrystalDemo::Title.new
      title.title = "Passengers"
      title.kind_id = kind_type.instance.id
      title.production_year = 2016

      changeset = CrystalDemo::Title.changeset(title)
      CrystalDemo::Repo.insert(changeset)

      get "/titles"

      kind_types = JSON.parse(response.body).map do |movie|
        movie["kind_type"].as_h.reject("id")
      end

      kind_types.should contain({ "name" => "episode" })
    end
  end
end
