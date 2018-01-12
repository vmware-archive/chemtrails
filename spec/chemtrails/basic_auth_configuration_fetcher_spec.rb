require 'spec_helper'

describe Chemtrails::BasicAuthConfigurationFetcher do
  let(:configuration_fetcher_double) { instance_double(Chemtrails::ConfigurationFetcher) }
  subject { Chemtrails::BasicAuthConfigurationFetcher.new(configuration_fetcher_double) }

  describe '#fetch_configuration' do
    it 'fetches configuration with a basic auth header' do
      allow(configuration_fetcher_double).to receive(:fetch_configuration)

      subject.fetch_configuration('http://config.server.url', 'my-rails-app', 'development', 'master', 'username', 'password')

      expected_auth_header = "Basic #{Base64.encode64('username:password').chomp}"
      expect(configuration_fetcher_double).to have_received(:fetch_configuration)
                                                  .with('http://config.server.url', 'my-rails-app', 'development', 'master', expected_auth_header)
    end
  end
end
