require "./spec_helper"

describe CrystalDemo do
  context "when there is a title" do
    it "should return all the titles" do
      title = CrystalDemo::Title.new
      title.title = "Passengers"
      title.kind_id = 1
      title.production_year = 2016

      changeset = CrystalDemo::Title.changeset(title)
      CrystalDemo::Repo.insert(changeset)

      get "/movies"

      movies = JSON.parse(response.body)
      movies = movies.select do |movie|
        movie["title"] == "Passengers"
      end

      movies.size.should eq 1
    end
  end

  context "when there is no title" do
    it "should return an empty array" do
      get "/movies"

      response.body.should eq("[]")
    end
  end
end
