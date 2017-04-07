module CrystalDemo
  module TitleApp
    get "/titles" do
      query = Crecto::Repo::Query
        .limit(10)
        .preload(:kind_type)

      titles = Repo.all(Title, query)
      (titles.as(Array).map &.to_hash).to_json
    end
  end
end
