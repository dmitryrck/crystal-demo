module CrystalDemo
  module TitleApp
    get "/titles" do |env|
      page = if env.params.query["page"]?
               env.params.query["page"][0].to_i - 1
             else
               0
             end

      query = Crecto::Repo::Query
        .limit(10)
        .offset(page * 10)
        .order_by("id DESC")
        .preload(:kind_type)

      titles = Repo.all(Title, query)
      (titles.as(Array).map &.to_hash).to_json
    end

    post "/titles" do |env|
      title = Title.from_json(env.params.json.to_json)
      changeset = CrystalDemo::Title.changeset(title)

      if changeset.valid?
        title = CrystalDemo::Repo.insert(changeset)
        title.instance.to_json
      else
        message = {
          "error" => 406,
          "message" => "Invalid",
          "errors" => changeset.errors
        }

        halt env, status_code: 406, response: message.to_json
      end
    end

    put "/titles/:id" do |env|
      title = Repo.get(Title, env.params.url["id"])

      if title
        title.from_json(env.params.json.to_json)
        changeset = CrystalDemo::Title.changeset(title)
        if changeset.valid?
          title = CrystalDemo::Repo.update(title)
          title.instance.to_json
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
