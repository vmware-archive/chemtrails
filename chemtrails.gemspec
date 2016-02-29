# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chemtrails/version'

Gem::Specification.new do |spec|
  spec.name          = 'chemtrails'
  spec.version       = Chemtrails::VERSION
  spec.authors       = ['Pivotal IAD']
  spec.email         = ['iad-dev@pivotal.io']

  spec.summary       = %q{Chemtrails is a gem used to integrate a Rails app with a Spring Cloud Config server.}
  spec.description   = %q{Chemtrails is a gem used to integrate a Rails app with a Spring Cloud Config server.}
  spec.homepage      = 'http://github.com/pivotal/chemtrails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.0'
  spec.add_dependency 'excon', '~> 0.45.0'

  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'rspec',    '~> 3.4'
  spec.add_development_dependency 'bundler',  '~> 1.0'
  spec.add_development_dependency 'webmock',  '~> 1.24'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'
end
