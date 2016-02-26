# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chemtrails/version'

Gem::Specification.new do |spec|
  spec.name          = 'chemtrails'
  spec.version       = Chemtrails::VERSION
  spec.authors       = ['Pivotal IAD']
  spec.email         = ['iad-dev@pivotal.io']

  spec.summary       = %q{Chemtrails is a gem that integrates with Spring Cloud Config to externalize the configuration of your Rails app.}
  spec.description   = %q{Chemtrails is a gem that integrates with Spring Cloud Config to externalize the configuration of your Rails app.}
  spec.homepage      = 'http://github.com/pivotal/chemtrails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.1.6'
  spec.add_dependency 'excon', '~> 0.45.4'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
