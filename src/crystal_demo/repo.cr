module CrystalDemo
  module Repo
    extend Crecto::Repo

    config do |conf|
      conf.uri = ENV["DATABASE_URL"]
      conf.initial_pool_size = (ENV["INITIAL_POOL_SIZE"]? || 100).to_i
      conf.max_pool_size = (ENV["MAX_POOL_SIZE"]? || 200).to_i
    end
  end
end
