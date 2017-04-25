module CrystalDemo
  module TitleApp
    extend CrystalDemo::Utils

    get "/titles" do |env|
      page = env.params.query.fetch("page", "1").to_i - 1

      query = Crecto::Repo::Query
        .limit(10)
        .offset(page * 10)
        .order_by("id desc")
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
        halt env, status_code: 406, response: invalid_message(changeset)
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
          halt env, status_code: 406, response: invalid_message(changeset)
        end
      else
        halt env, status_code: 404, response: not_found_message
      end
    end
  end
end
