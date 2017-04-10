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

auth_token_mw = Kemal::AuthToken.new(secret_key: ENV["SECRET_KEY"])
auth_token_mw.sign_in do |id, md5sum|
  CrystalDemo::User.sign_in(id, md5sum)
end
auth_token_mw.load_user do |user|
  CrystalDemo::User.load_user(user)
end
Kemal.config.add_handler(auth_token_mw)

module CrystalDemo
  before_all do |env|
    env.response.content_type = "application/json"
  end

  before_all do |env|
    if env.request.path != "/sign_in" && env.current_user.empty?
      message = { "error" => 403, "message" => "Forbidden" }

      halt env, status_code: 403, response: message.to_json
    end
  end

  get "/current_user" do |env|
    env.current_user.to_json
  end

  post "/sign_in" do |env|
    message = { "error" => 400, "message" => "Your id and md5sum does not match" }

    halt env, status_code: 403, response: message.to_json
  end
end

if ENV["PORT"]?
  Kemal.config.port = ENV["PORT"].to_i
end

Kemal.run
