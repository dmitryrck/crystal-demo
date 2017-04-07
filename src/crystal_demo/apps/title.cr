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
  end
end
