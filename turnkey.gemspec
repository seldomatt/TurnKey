# -*- encoding: utf-8 -*-
require File.expand_path('../lib/turnkey/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "turnkey"
  s.version     = Turnkey::VERSION
  s.summary     = "RubyMotion utility for saving custom objects to disk"
  s.description = "TurnKey allows you to save custom objects to disk without implementing NSCoder protocols"
  s.author      = "Matthew Salerno"
  s.email       = "matthewsalern@gmail.com"
  s.homepage    = "https://github.com/seldomatt/turnkey"
  s.license     = "MIT"
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.add_runtime_dependency("motion-require", ">= 0.0.6")
end