require 'spec_helper'

describe Chemtrails::OAuthConfigurationFetcher do
  let(:configuration_fetcher_double) {instance_double(Chemtrails::ConfigurationFetcher)}
  subject {Chemtrails::OAuthConfigurationFetcher.new(configuration_fetcher_double)}

  describe 'fetch_configuration' do
    it 'fetches an access token and then fetches the specified configuration' do
      allow(configuration_fetcher_double).to receive(:fetch_configuration)
      stub_request(:post, 'http://config.server.oauth.url/oauth/token')
          .with(body: {
              'client_id' => 'client-id',
              'client_secret' => 'client-secret',
              'grant_type' => 'client_credentials'
          })
          .to_return(status: 200, body: {'access_token' => 'stubbed-access-token'}.to_json)

      subject.fetch_configuration(
          app_name: 'my-rails-app',
          branch: 'master',
          profiles: 'development',
          config_server_url: 'http://config.server.url',
          access_token_url: 'http://config.server.oauth.url/oauth/token',
          client_id: 'client-id',
          client_secret: 'client-secret'
      )

      expect(configuration_fetcher_double).to have_received(:fetch_configuration)
                                                  .with('http://config.server.url', 'my-rails-app', 'development', 'master', 'Bearer stubbed-access-token')
    end

    it 'raises a useful error when the token request fails' do
      allow(configuration_fetcher_double).to receive(:fetch_configuration)
      stub_request(:post, 'http://config.server.oauth.url/oauth/token').to_return(status: 403, body: 'something went wrong')

      expect {
        subject.fetch_configuration(
            app_name: 'my-rails-app',
            branch: 'master',
            profiles: 'development',
            config_server_url: 'http://config.server.url',
            access_token_url: 'http://config.server.oauth.url/oauth/token',
            client_id: 'client-id',
            client_secret: 'client-secret'
        )
      }.to raise_error("Failed to get access token from http://config.server.oauth.url/oauth/token. HTTP 403: 'something went wrong'")
    end
  end
end