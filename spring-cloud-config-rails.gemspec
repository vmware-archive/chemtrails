# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spring/cloud/config/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'spring-cloud-config-rails'
  spec.version       = Spring::Cloud::Config::Rails::VERSION
  spec.authors       = ['Pivotal IAD']
  spec.email         = ['iad-dev@pivotal.io']

  spec.summary       = %q{spring-cloud-config is a gem that provides configuration with Spring Cloud Config.}
  spec.description   = %q{spring-cloud-config is a gem that provides configuration with Spring Cloud Config.}
  spec.homepage      = 'http://github.com/pivotal/spring-cloud-config'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 4.1.6'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
