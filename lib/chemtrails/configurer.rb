module Chemtrails
  class Configurer
    def initialize(basic_auth_configuration_fetcher:, oauth_configuration_fetcher:)
      @basic_auth_configuration_fetcher = basic_auth_configuration_fetcher
      @oauth_configuration_fetcher = oauth_configuration_fetcher
    end

    def configure(app_name:, rails_env:, env:)
      use_p_config_server_service = env['USE_P_CONFIG_SERVER_SERVICE']
      server = env['CONFIG_SERVER_URL']
      branch = env['CONFIG_SERVER_BRANCH']
      username = env['CONFIG_SERVER_USERNAME']
      password = env['CONFIG_SERVER_PASSWORD']
      profiles = env.fetch('CONFIG_SERVER_PROFILE_ACTIVE', rails_env)

      if use_p_config_server_service == 'true'
        vcap_services = env.fetch('VCAP_SERVICES') {fail('USE_P_CONFIG_SERVER_SERVICE=true but no VCAP_SERVICES variable is present. Are you running on a CF?')}
        config_server_services_json = JSON.parse(vcap_services).fetch('p-config-server') {fail('USE_P_CONFIG_SERVER_SERVICE=true but no p-config-server in VCAP_SERVICES. Have you bound the service?')}
        config_server_service_json = config_server_services_json.first

        env_vars_from_config_server = @oauth_configuration_fetcher.fetch_configuration(
            app_name: app_name,
            branch: branch,
            profiles: profiles,
            config_server_url: config_server_service_json.fetch('credentials').fetch('uri'),
            access_token_url: config_server_service_json.fetch('credentials').fetch('access_token_uri'),
            client_id: config_server_service_json.fetch('credentials').fetch('client_id'),
            client_secret: config_server_service_json.fetch('credentials').fetch('client_secret'),
        )
        env.update(env_vars_from_config_server)
      elsif server.present?
        env_vars_from_config_server = @basic_auth_configuration_fetcher.fetch_configuration(server, app_name, profiles, branch, username, password)
        env.update(env_vars_from_config_server)
      else
        puts "No CONFIG_SERVER_URL provided, Chemtrails will not fetch environment variables"
      end
    end
  end
end