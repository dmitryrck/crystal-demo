module CrystalDemo
  module NameApp
    extend CrystalDemo::MessageUtils

    get "/names" do |env|
      page = env.params.query.fetch("page", "1").to_i - 1

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
        halt env, status_code: 406, response: invalid(changeset)
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
          halt env, status_code: 406, response: invalid(changeset)
        end
      else
        halt env, status_code: 404, response: not_found
      end
    end
  end
end
