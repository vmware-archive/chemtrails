require 'chemtrails/basic_auth_configuration_fetcher'

module Chemtrails
  class Configurer
    def initialize(fetcher:)
      @fetcher = fetcher
    end

    def configure(app_name:, rails_env:, env:)
      server = env['CONFIG_SERVER_URL']
      branch = env['CONFIG_SERVER_BRANCH']
      username = env['CONFIG_SERVER_USERNAME']
      password = env['CONFIG_SERVER_PASSWORD']
      profiles = env.fetch('CONFIG_SERVER_PROFILE_ACTIVE', rails_env)

      if server.present?
        env_vars_from_config_server = @fetcher.fetch_configuration(server, app_name, profiles, branch, username, password)
        env.update(env_vars_from_config_server)
      else
        puts "No CONFIG_SERVER_URL provided, Chemtrails will not fetch environment variables"
      end
    end
  end
end