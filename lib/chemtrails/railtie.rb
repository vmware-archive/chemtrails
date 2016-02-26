require 'rails'

module Chemtrails
  class Railtie < Rails::Railtie
    config.before_configuration { startup unless Rails.env.test? }

    def self.startup
      server = ENV['CONFIG_SERVER_URL']
      username = ENV['CONFIG_SERVER_USERNAME']
      password = ENV['CONFIG_SERVER_PASSWORD']
      fetcher = Chemtrails::Fetcher.new(server, app_name, app_environment, username, password)
      ENV.update(fetcher.fetch_configuration)
    end

    private

    def self.app_name
      Rails.application.class.parent.to_s.downcase
    end

    def self.app_environment
      Rails.env
    end
  end
end
