require 'json'
require 'excon'

module Chemtrails
  class Fetcher
    def initialize(url, application, environment, username, password)
      @url = url
      @application = application
      @environment = environment
      @username = username
      @password = password
    end

    def fetch_configuration
      response = Excon.get("#{@url}/#{@application}/#{@environment}", headers: {
        'Authorization' => "Basic #{encode_credentials(@username, @password)}"
      })

      if success?(response)
        json = JSON.parse(response.body)
        {}.tap do |props|
          sources = json['propertySources']
          sources.each { |source| props.reverse_merge!(source['source']) }
        end
      else
        raise RuntimeError.new("Error fetching configuration from: #{@url}")
      end
    end

    private

    def success?(response)
      response.status >= 200 && response.status < 400
    end

    def encode_credentials(username, password)
      Base64.encode64("#{username}:#{password}").chomp
    end
  end
end
