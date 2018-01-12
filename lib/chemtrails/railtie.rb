require 'rails'
require 'chemtrails/configurer'
require 'chemtrails/basic_auth_configuration_fetcher'
require 'chemtrails/oauth_configuration_fetcher'
require 'chemtrails/configuration_fetcher'

module Chemtrails
  class Railtie < Rails::Railtie
    config.before_configuration do
      startup(Rails.application.class.parent.to_s.downcase, Rails.env, ENV) unless Rails.env.test?
    end

    def self.startup(app_name, rails_env, env)
      configuration_fetcher = ConfigurationFetcher.new
      configurer = Configurer.new(
          basic_auth_configuration_fetcher: BasicAuthConfigurationFetcher.new(configuration_fetcher),
          oauth_configuration_fetcher: OAuthConfigurationFetcher.new(configuration_fetcher),
      )
      configurer.configure(app_name: app_name, rails_env: rails_env, env: env)
    end
  end
end
