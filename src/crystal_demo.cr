require "kemal"

require "pg"
require "crecto"
require "./crystal_demo/repo"
require "./crystal_demo/models/*"

require "./crystal_demo/*"
require "./crystal_demo/apps/*"

module CrystalDemo
  extend CrystalDemo::Utils
  extend CrystalDemo::Auth

  before_all do |env|
    env.response.content_type = "application/json"
  end

  before_all do |env|
    unless auth(env.request.headers)
      halt env, status_code: 403, response: forbidden_message
    end
  end

  get "/current_user" do |env|
    name = auth(env.request.headers)
    name && name.to_json
  end
end

if ENV["PORT"]?
  Kemal.config.port = ENV["PORT"].to_i
end

Kemal.run
