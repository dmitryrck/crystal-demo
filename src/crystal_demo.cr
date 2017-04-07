require "kemal"

require "pg"
require "crecto"
require "./crystal_demo/repo"
require "./crystal_demo/models/*"
require "./crystal_demo/apps/*"

require "./crystal_demo/*"

module CrystalDemo
end

Kemal.run
