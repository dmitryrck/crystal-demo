module CrystalDemo
  module NameApp
    get "/names" do |env|
      page = if env.params.query["page"]?
               env.params.query["page"][0].to_i - 1
             else
               0
             end

      query = Crecto::Repo::Query
        .limit(10)
        .offset(page * 10)
        .order_by("id desc")

      names = Repo.all(Name, query)
      (names.as(Array).map &.to_hash).to_json
    end

    post "/names" do |env|
      name = Name.from_json(env.params.json.to_json)
      changeset = CrystalDemo::Name.changeset(name)

      if changeset.valid?
        name = CrystalDemo::Repo.insert(changeset)
        name.instance.to_json
      else
        message = {
          "error" => 406,
          "message" => "Invalid",
          "errors" => changeset.errors
        }

        halt env, status_code: 406, response: message.to_json
      end
    end

    put "/names/:id" do |env|
      name = Repo.get(Name, env.params.url["id"])

      if name
        name.from_json(env.params.json.to_json)
        changeset = CrystalDemo::Name.changeset(name)
        if changeset.valid?
          name = CrystalDemo::Repo.update(name)
          name.instance.to_json
        else
          message = {
            "error" => 406,
            "message" => "Invalid",
            "errors" => changeset.errors
          }

          halt env, status_code: 406, response: message.to_json
        end
      else
        message = { "error" => 404, "message" => "Not Found" }

        halt env, status_code: 404, response: message.to_json
      end
    end
  end
end
