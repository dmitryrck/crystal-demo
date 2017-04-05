ENV["KEMAL_ENV"] = "test"

require "spec"
require "spec-kemal"
require "../src/crystal_demo"

Spec.before_each do
  db = DB.open(ENV["DATABASE_URL"])
  db.exec("truncate title")
end
