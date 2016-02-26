require 'bundler/setup'
Bundler.setup

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'chemtrails'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true, allow: 'codeclimate.com')
