module CrystalDemo
  module TitleApp
    get "/titles" do
      query = Crecto::Repo::Query
        .limit(10)

      titles = Repo.all(Title, query)
      titles.as(Array).to_json
    end
  end
end
