# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-scm-rsync'
  spec.version       = '0.1.0'
  spec.authors       = ['Alexander Groß']
  spec.email         = %w(agross@therightstuff.de)

  spec.summary       = 'capistrano deployments using rsync as the SCM'
  spec.description   = 'Uses rsync to copy a local directory to your deployment servers'
  spec.homepage      = 'https://github.com/agross/capistrano-scm-rsync'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_dependency 'capistrano', '~> 3.7'
end
