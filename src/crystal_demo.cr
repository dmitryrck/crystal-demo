require "kemal"
require "kemal-auth-token/kemal-auth"
require "./kemal-auth-token-monkey-patch"

require "pg"
require "crecto"
require "./crystal_demo/repo"
require "./crystal_demo/models/*"
require "./crystal_demo/apps/*"

require "./crystal_demo/*"

ENV["SECRET_KEY"] ||= "secret key"

module CrystalDemo
  extend CrystalDemo::Auth

  before_all do |env|
    env.response.content_type = "application/json"
  end

  before_all do |env|
    unless auth(env.request.headers)
      message = { "error" => 403, "message" => "Forbidden" }

      halt env, status_code: 403, response: message.to_json
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
