require "./spec_helper"

describe CrystalDemo do
  context "GET /current_user" do
    context "when user is not authenticated" do
      it "should return forbidden message" do
        get "/current_user"

        response.body.should eq %({"error":403,"message":"Forbidden"})
      end
    end

    context "when user provides a wrong token" do
      it "should return forbidden message" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d3"}

        get "/current_user", headers

        response.body.should eq %({"error":403,"message":"Forbidden"})
      end
    end

    context "when user is authenticated" do
      it "should return user's md5sum" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}

        get "/current_user", headers: headers

        JSON.parse(response.body)["md5sum"].should eq "cf45e7b42fbc800c61462988ad1156d2"
      end

      it "should return user's name" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}

        get "/current_user", headers: headers

        JSON.parse(response.body)["name"].should eq "John"
      end

      it "should return user's id" do
        name = CrystalDemo::Name.new
        name.name = "John"
        name.md5sum = "cf45e7b42fbc800c61462988ad1156d2"
        changeset = CrystalDemo::Name.changeset(name)
        name = CrystalDemo::Repo.insert(changeset)
        headers = HTTP::Headers{"Authorization" => "Token token:cf45e7b42fbc800c61462988ad1156d2"}

        get "/current_user", headers: headers

        JSON.parse(response.body)["id"].should_not be_nil
      end
    end
  end
end
