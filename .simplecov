#!/usr/bin/env ruby

require 'pathname'
require 'coveralls'

SimpleCov.start do
  track_files('lib/**/*.rb')

  add_filter do |file|
    relative_path = Pathname.new(file.filename)
                            .relative_path_from(Pathname.new(SimpleCov.root))
    relative_path.to_s =~ %r{^spec/}
  end

  coverage_dir('coverage')

  format = [::SimpleCov::Formatter::HTMLFormatter]
  format << Coveralls::SimpleCov::Formatter if Coveralls.will_run?

  formatter(::SimpleCov::Formatter::MultiFormatter.new(format))
end
