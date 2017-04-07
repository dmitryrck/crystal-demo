module CrystalDemo
  module Repo
    extend Crecto::Repo

    config do |conf|
      conf.uri = ENV["DATABASE_URL"]
    end
  end
end
