require "../../spec_helper"

describe CrystalDemo::TitleApp do
  context "when user is not authenticated" do
    context "when user is not authenticated" do
      it "should return forbidden error" do
        get "/titles"

        response.body.should eq %({"error":403,"message":"Forbidden"})
      end
    end
  end

  context "when user is authenticated" do
    it "should return an empty array" do
      name = CrystalDemo::Name.new
      name.name = "John"
      name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
      changeset = CrystalDemo::Name.changeset(name)
      name = CrystalDemo::Repo.insert(changeset)
      headers = HTTP::Headers.new
      headers["X-Token"] = token(name)

      get "/titles", headers: headers

      response.body.should eq("[]")
    end
  end

  describe "when user is authenticated" do
    context "when there is no title" do
      it "should return an empty array" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers.new
        headers["X-Token"] = token(name)

        get "/titles", headers: headers

        response.body.should eq("[]")
      end
    end

    context "when there is a title" do
      it "should return first page" do
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

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers.new
        headers["X-Token"] = token(name)

        get "/titles", headers: headers

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

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers.new
        headers["X-Token"] = token(name)

        get "/titles", headers: headers

        kind_types = JSON.parse(response.body).map do |movie|
          movie["kind_type"].as_h.reject("id")
        end

        kind_types.should contain({ "name" => "episode" })
      end
    end

    context "when paginating" do
      context "should return first page" do
        it "when has no page params" do
          kind_type = CrystalDemo::KindType.new
          kind_type.kind = "episode"
          kind_type = CrystalDemo::KindType.changeset(kind_type)
          kind_type = CrystalDemo::Repo.insert(kind_type)

          1.upto(30).each do |number|
            title = CrystalDemo::Title.new
            title.title = "Movie##{number}"
            title.kind_id = kind_type.instance.id
            title.production_year = 2017
            changeset = CrystalDemo::Title.changeset(title)
            CrystalDemo::Repo.insert(changeset)
          end

          name = CrystalDemo::Name.new
          name.name = "John"
          name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
          changeset = CrystalDemo::Name.changeset(name)
          name = CrystalDemo::Repo.insert(changeset)
          headers = HTTP::Headers.new
          headers["X-Token"] = token(name)

          get "/titles", headers: headers

          JSON.parse(response.body).map { |movie| movie["title"] }.should eq(
            [
              "Movie#30", "Movie#29", "Movie#28", "Movie#27", "Movie#26", "Movie#25",
              "Movie#24", "Movie#23", "Movie#22", "Movie#21"
            ]
          )
        end

        it "when page params is equals to 1" do
          kind_type = CrystalDemo::KindType.new
          kind_type.kind = "episode"
          kind_type = CrystalDemo::KindType.changeset(kind_type)
          kind_type = CrystalDemo::Repo.insert(kind_type)

          1.upto(30).each do |number|
            title = CrystalDemo::Title.new
            title.title = "Movie##{number}"
            title.kind_id = kind_type.instance.id
            title.production_year = 2017
            changeset = CrystalDemo::Title.changeset(title)
            CrystalDemo::Repo.insert(changeset)
          end

          name = CrystalDemo::Name.new
          name.name = "John"
          name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
          changeset = CrystalDemo::Name.changeset(name)
          name = CrystalDemo::Repo.insert(changeset)
          headers = HTTP::Headers.new
          headers["X-Token"] = token(name)

          get "/titles?page=1", headers: headers

          JSON.parse(response.body).map { |movie| movie["title"] }.should eq(
            [
              "Movie#30", "Movie#29", "Movie#28", "Movie#27", "Movie#26", "Movie#25",
              "Movie#24", "Movie#23", "Movie#22", "Movie#21"
            ]
          )
        end
      end

      it "should return second page" do
        kind_type = CrystalDemo::KindType.new
        kind_type.kind = "episode"
        kind_type = CrystalDemo::KindType.changeset(kind_type)
        kind_type = CrystalDemo::Repo.insert(kind_type)

        1.upto(30).each do |number|
          title = CrystalDemo::Title.new
          title.title = "Movie##{number}"
          title.kind_id = kind_type.instance.id
          title.production_year = 2017
          changeset = CrystalDemo::Title.changeset(title)
          CrystalDemo::Repo.insert(changeset)
        end

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers.new
        headers["X-Token"] = token(name)

        get "/titles?page=2", headers: headers

        JSON.parse(response.body).map { |movie| movie["title"] }.should eq(
          [
            "Movie#20", "Movie#19", "Movie#18", "Movie#17", "Movie#16", "Movie#15",
            "Movie#14", "Movie#13", "Movie#12", "Movie#11"
          ]
        )
      end
    end
  end
end
