# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "turnkey"
  s.version     = '0.0.1'
  s.summary     = "RubyMotion utility for saving custom objects to disk"
  s.description = "TurnKey allows you to save custom objects to disk without implementing NSCoder protocols"
  s.author      = "Matthew Salerno"
  s.email       = "matthewsalern@gmail.com"
  s.homepage    = "https://github.com/seldomatt/turnkey"
  s.license     = "MIT"

  files = []
  files << 'README.md'
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  s.files = files
end