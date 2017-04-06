require "kemal"

require "pg"
require "crecto"
require "./crystal_demo/repo"
require "./crystal_demo/models/*"

require "./crystal_demo/*"

module CrystalDemo
  get "/movies" do
    query = Crecto::Repo::Query
      .limit(10)

    titles = Repo.all(Title, query)
    titles.as(Array).to_json
  end
end

Kemal.run
