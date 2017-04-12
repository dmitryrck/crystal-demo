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

  describe "when user is authenticated" do
    context "POST /titles" do
      it "should create" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"X-Token" => token(name), "Content-Type" => "application/json"}
        body = { "title": "Ghost in the shell", "production_year": 2017, "kind_id": 1 }

        post "/titles", headers: headers, body: body.to_json

        json = JSON.parse(response.body)

        json["title"].should eq "Ghost in the shell"
        json["production_year"].should eq 2017
        json["kind_id"].should eq 1
        json["id"].should_not be_nil
      end

      it "should not create" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"X-Token" => token(name), "Content-Type" => "application/json"}
        body = { "production_year": 2017, "kind_id": 1 }

        post "/titles", headers: headers, body: body.to_json

        response.status_code.should eq 406
        response.body.should eq %({"error":406,"message":"Invalid","errors":[{"field":"title","message":"is required"}]})
      end
    end

    context "PUT /titles/1" do
      it "should update" do
        kind_type = CrystalDemo::KindType.new
        kind_type.kind = "episode"
        kind_type = CrystalDemo::KindType.changeset(kind_type)
        kind_type = CrystalDemo::Repo.insert(kind_type)

        title = CrystalDemo::Title.new
        title.title = "Passengers"
        title.kind_id = kind_type.instance.id
        title.production_year = 2016
        changeset = CrystalDemo::Title.changeset(title)
        title = CrystalDemo::Repo.insert(changeset)

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"X-Token" => token(name), "Content-Type" => "application/json"}
        body = { "title": "Ghost in the shell (Anime)", "production_year": 1995 }

        put "/titles/#{title.instance.id}", headers: headers, body: body.to_json

        json = JSON.parse(response.body)

        json["title"].should eq "Ghost in the shell (Anime)"
        json["production_year"].should eq 1995
        json["id"].should eq title.instance.id

        title = CrystalDemo::Repo.get(CrystalDemo::Title, title.instance.id).as(CrystalDemo::Title)
        title.production_year.should eq 1995
      end

      it "should not update" do
        kind_type = CrystalDemo::KindType.new
        kind_type.kind = "episode"
        kind_type = CrystalDemo::KindType.changeset(kind_type)
        kind_type = CrystalDemo::Repo.insert(kind_type)

        title = CrystalDemo::Title.new
        title.title = "Passengers"
        title.kind_id = kind_type.instance.id
        title.production_year = 2016
        changeset = CrystalDemo::Title.changeset(title)
        title = CrystalDemo::Repo.insert(changeset)

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"X-Token" => token(name), "Content-Type" => "application/json"}
        body = { "title": "", "production_year": 1995 }

        put "/titles/#{title.instance.id}", headers: headers, body: body.to_json

        response.body.should eq %({"error":406,"message":"Invalid","errors":[{"field":"title","message":"is invalid"}]})
      end
    end

    context "GET /titles" do
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
end
