ENV["KEMAL_ENV"] = "test"
ENV["SECRET_KEY"] = "super secret key"

require "spec"
require "spec-kemal"
require "../src/crystal_demo"

Spec.before_each do
  db = DB.open(ENV["DATABASE_URL"])
  db.exec("truncate title, name")
end

def token(name = CrystalDemo::Name, secret_key = nil)
  playload = UserHash.new
  playload["id"] = name.instance.id.to_s
  playload["password"] = name.instance.md5sum

  JWT.encode(playload, (secret_key || ENV["SECRET_KEY"]), "HS256")
end
