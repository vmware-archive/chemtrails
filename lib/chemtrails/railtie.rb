require 'rails'

module Chemtrails
  class Railtie < Rails::Railtie
    config.before_configuration do
      startup(Rails.application.class.parent.to_s.downcase, Rails.env, ENV) unless Rails.env.test?
    end

    def self.startup(app_name, rails_env, env)
      server = env['CONFIG_SERVER_URL']
      branch = env['CONFIG_SERVER_BRANCH']
      username = env['CONFIG_SERVER_USERNAME']
      password = env['CONFIG_SERVER_PASSWORD']
      profiles = env.fetch('CONFIG_SERVER_PROFILE_ACTIVE', rails_env)

      fetcher = Chemtrails::Fetcher.new(server, app_name, profiles, branch, username, password)
      env.update(fetcher.fetch_configuration)
    end
  end
end
