unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require "motion-require"

Motion::Require.all(Dir.glob(File.expand_path('../turnkey/**/*.rb', __FILE__)))
