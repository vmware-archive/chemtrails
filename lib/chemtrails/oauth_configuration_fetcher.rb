module Chemtrails
  class OAuthConfigurationFetcher
    def initialize(configuration_fetcher)
      @configuration_fetcher = configuration_fetcher
    end

    def fetch_configuration(app_name:, branch:, profiles:, config_server_url:, access_token_url:, client_id:, client_secret:)
      access_token = fetch_access_token(access_token_url, client_id, client_secret)
      @configuration_fetcher.fetch_configuration(config_server_url, app_name, profiles, branch, "Bearer #{access_token}")
    end

    private

    def fetch_access_token(access_token_url, client_id, client_secret)
      token_response = Excon.post(
          access_token_url,
          headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
          },
          body: URI.encode_www_form({
                                        client_id: client_id,
                                        client_secret: client_secret,
                                        grant_type: 'client_credentials'
                                    })
      )

      if token_response.status < 200 || token_response.status >= 400
        raise "Failed to get access token from #{access_token_url}. HTTP #{token_response.status}: '#{token_response.body}'"
      end

      JSON.parse(token_response.body).fetch('access_token')
    end
  end
end