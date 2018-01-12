module Chemtrails
  class BasicAuthConfigurationFetcher
    def initialize(configuration_fetcher)
      @configuration_fetcher = configuration_fetcher
    end

    def fetch_configuration(url, application, environment, branch, username, password)
      auth_header = "Basic #{encode_credentials(username, password)}"
      @configuration_fetcher.fetch_configuration(url, application, environment, branch, auth_header)
    end

    private

    def encode_credentials(username, password)
      Base64.encode64("#{username}:#{password}").chomp
    end
  end
end
