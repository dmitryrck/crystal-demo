require "uri"

module CrystalDemo
  module Repo
    extend Crecto::Repo

    database_url = URI.parse(ENV["DATABASE_URL"])

    config do |conf|
      conf.adapter = Crecto::Adapters::Postgres
      conf.database = database_url.path.as(String).gsub("/", "")
      conf.hostname = database_url.host || "127.0.0.1"
      conf.username = database_url.user || "postgres"
      conf.password = database_url.password || "postgres"
      # conf.port     = ENV["DATABASE_PORT"]? || 5342
    end
  end
end
