require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--order random --format progress --format html --out build/spec/rspec.html #{ENV['RSPEC_OPTS']}"
end
