require "../../spec_helper"

describe CrystalDemo::NameApp do
  context "when user is not authenticated" do
    context "when user is not authenticated" do
      it "should return forbidden error" do
        get "/names.json"

        response.body.should eq %({"error":403,"message":"Forbidden"})
      end
    end
  end

  describe "when user is authenticated" do
    context "POST /names" do
      it "should create" do
        auth = CrystalDemo::Name.new
        auth.name = "John"
        auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(auth)
        auth = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2", "Content-Type" => "application/json"}
        body = { "name": "Jane Doe", "md5sum": "abc" }
        post "/names", headers: headers, body: body.to_json

        json = JSON.parse(response.body)
        json["name"].should eq "Jane Doe"
        json["md5sum"].should eq "abc"
      end

      it "should not create" do
        auth = CrystalDemo::Name.new
        auth.name = "John"
        auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        auth = CrystalDemo::Name.changeset(auth)
        CrystalDemo::Repo.insert(auth)

        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2" , "Content-Type" => "application/json"}
        body = { "md5sum": "abc" }
        post "/names", headers: headers, body: body.to_json

        response.status_code.should eq 406
        response.body.should eq %({"error":406,"message":"Invalid","errors":[{"field":"name","message":"is required"}]})
      end
    end

    context "PUT /names/1" do
      it "should update" do
        auth = CrystalDemo::Name.new
        auth.name = "Jane"
        auth.md5sum = "abc"
        changeset = CrystalDemo::Name.changeset(auth)
        auth = CrystalDemo::Repo.insert(changeset)

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2", "Content-Type" => "application/json"}
        body = { "name": "Jane Doe", "md5sum": "abcd" }
        put "/names/#{name.instance.id}", headers: headers, body: body.to_json

        json = JSON.parse(response.body)
        json["name"].should eq "Jane Doe"
        json["md5sum"].should eq "abcd"
        json["id"].should eq name.instance.id

        name = CrystalDemo::Repo.get(CrystalDemo::Name, name.instance.id).as(CrystalDemo::Name)
        name.name.should eq "Jane Doe"
        name.md5sum.should eq "abcd"
      end

      it "should not update" do
        auth = CrystalDemo::Name.new
        auth.name = "Jane"
        auth.md5sum = "abc"
        changeset = CrystalDemo::Name.changeset(auth)
        auth = CrystalDemo::Repo.insert(changeset)

        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)

        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2", "Content-Type" => "application/json"}
        body = { "name": "", "md5sum": "abcd" }
        put "/names/#{name.instance.id}", headers: headers, body: body.to_json

        response.body.should eq %({"error":406,"message":"Invalid","errors":[{"field":"name","message":"is invalid"}]})
      end
    end

    context "GET /names.json" do
      it "should return first page" do
        name = CrystalDemo::Name.new
        name.name = "Jane"
        name.md5sum = "abc"
        changeset = CrystalDemo::Name.changeset(name)
        CrystalDemo::Repo.insert(changeset)

        auth = CrystalDemo::Name.new
        auth.name = "John"
        auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        auth = CrystalDemo::Name.changeset(auth)
        CrystalDemo::Repo.insert(auth)

        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}
        get "/names.json", headers: headers

        JSON.parse(response.body).map { |movie| movie["name"] }.should contain("Jane")
      end

      context "when paginating" do
        context "should return first page" do
          it "when has no page params" do
            auth = CrystalDemo::Name.new
            auth.name = "John"
            auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
            changeset = CrystalDemo::Name.changeset(auth)
            auth = CrystalDemo::Repo.insert(changeset)

            1.upto(30).each do |number|
              name = CrystalDemo::Name.new
              name.name = "User##{number}"
              name.md5sum = "abc"
              changeset = CrystalDemo::Name.changeset(name)
              CrystalDemo::Repo.insert(changeset)
            end

            headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}

            get "/names.json", headers: headers

            JSON.parse(response.body).map { |movie| movie["name"] }.should eq(
              [
                "User#30", "User#29", "User#28", "User#27", "User#26", "User#25",
                "User#24", "User#23", "User#22", "User#21"
              ]
            )
          end

          it "when page params is equals to 1" do
            auth = CrystalDemo::Name.new
            auth.name = "John"
            auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
            changeset = CrystalDemo::Name.changeset(auth)
            auth = CrystalDemo::Repo.insert(changeset)

            1.upto(30).each do |number|
              name = CrystalDemo::Name.new
              name.name = "User##{number}"
              name.md5sum = "abc"
              changeset = CrystalDemo::Name.changeset(name)
              CrystalDemo::Repo.insert(changeset)
            end

            headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}

            get "/names.json?page=1", headers: headers

            JSON.parse(response.body).map { |movie| movie["name"] }.should eq(
              [
                "User#30", "User#29", "User#28", "User#27", "User#26", "User#25",
                "User#24", "User#23", "User#22", "User#21"
              ]
            )
          end
        end

        it "should return second page" do
          auth = CrystalDemo::Name.new
          auth.name = "John"
          auth.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
          changeset = CrystalDemo::Name.changeset(auth)
          auth = CrystalDemo::Repo.insert(changeset)

          1.upto(30).each do |number|
            name = CrystalDemo::Name.new
            name.name = "User##{number}"
            name.md5sum = "abc"
            changeset = CrystalDemo::Name.changeset(name)
            CrystalDemo::Repo.insert(changeset)
          end

          headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}
          get "/names.json?page=2", headers: headers

          JSON.parse(response.body).map { |movie| movie["name"] }.should eq(
            [
              "User#20", "User#19", "User#18", "User#17", "User#16", "User#15",
              "User#14", "User#13", "User#12", "User#11"
            ]
          )
        end
      end
    end
  end
end
