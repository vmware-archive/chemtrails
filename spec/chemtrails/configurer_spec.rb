require 'spec_helper'

describe Chemtrails::Configurer do
  describe '#configure' do
    let(:basic_auth_fetcher) {instance_double(Chemtrails::BasicAuthConfigurationFetcher)}
    let(:oauth_fetcher) {instance_double(Chemtrails::OAuthConfigurationFetcher)}

    let(:configurer) {
      Chemtrails::Configurer.new(
          basic_auth_configuration_fetcher: basic_auth_fetcher,
          oauth_configuration_fetcher: oauth_fetcher
      )
    }

    context 'when USE_P_CONFIG_SERVER_SERVICE is true and using p-config-server' do
      it 'should use an OAuthConfigurationFetcher' do
        vcap_services = {
            'p-config-server': [
                {
                    'credentials': {
                        'uri': 'http://config.server.url',
                        'client_secret': 'secret',
                        'client_id': 'id',
                        'access_token_uri': 'http://config.server.access.token.url'
                    }
                }
            ]
        }

        allow(oauth_fetcher).to receive(:fetch_configuration)
                                    .with(
                                        app_name: 'test',
                                        branch: 'branch',
                                        profiles: 'migration',
                                        config_server_url: 'http://config.server.url',
                                        access_token_url: 'http://config.server.access.token.url',
                                        client_id: 'id',
                                        client_secret: 'secret'
                                    )
                                    .and_return({'new_configuration' => 'values'})


        env = {
            'USE_P_CONFIG_SERVER_SERVICE' => 'true',
            'CONFIG_SERVER_BRANCH' => 'branch',
            'VCAP_SERVICES' => vcap_services.to_json
        }

        configurer.configure(app_name: 'test', rails_env: 'migration', env: env)

        expect(env).to eq({
                                 'USE_P_CONFIG_SERVER_SERVICE' => 'true',
                                 'CONFIG_SERVER_BRANCH' => 'branch',
                                 'VCAP_SERVICES' => vcap_services.to_json,
                                 'new_configuration' => 'values'
                             })
      end

      it 'spring profiles active stuff' do

      end
    end

    context 'when USE_P_CONFIG_SERVER_SERVICE is true and using p.config-server' do
      it 'should use an OAuthConfigurationFetcher' do
        vcap_services = {
            'p.config-server': [
                {
                    'credentials': {
                        'uri': 'http://config.server.url',
                        'client_secret': 'secret',
                        'client_id': 'id',
                        'access_token_uri': 'http://config.server.access.token.url'
                    }
                }
            ]
        }

        allow(oauth_fetcher).to receive(:fetch_configuration)
                                    .with(
                                        app_name: 'test',
                                        branch: 'branch',
                                        profiles: 'migration',
                                        config_server_url: 'http://config.server.url',
                                        access_token_url: 'http://config.server.access.token.url',
                                        client_id: 'id',
                                        client_secret: 'secret'
                                    )
                                    .and_return({'new_configuration' => 'values'})


        env = {
            'USE_P_CONFIG_SERVER_SERVICE' => 'true',
            'CONFIG_SERVER_BRANCH' => 'branch',
            'VCAP_SERVICES' => vcap_services.to_json
        }

        configurer.configure(app_name: 'test', rails_env: 'migration', env: env)

        expect(env).to eq({
                              'USE_P_CONFIG_SERVER_SERVICE' => 'true',
                              'CONFIG_SERVER_BRANCH' => 'branch',
                              'VCAP_SERVICES' => vcap_services.to_json,
                              'new_configuration' => 'values'
                          })
      end

      it 'spring profiles active stuff' do

      end
    end

    context 'when USE_P_CONFIG_SERVER_SERVICE is true and no config server' do
      it 'should use an OAuthConfigurationFetcher' do
        vcap_services = {

        }

        allow(oauth_fetcher).to receive(:fetch_configuration)
                                    .with(
                                        app_name: 'test',
                                        branch: 'branch',
                                        profiles: 'migration',
                                        config_server_url: 'http://config.server.url',
                                        access_token_url: 'http://config.server.access.token.url',
                                        client_id: 'id',
                                        client_secret: 'secret'
                                    )
                                    .and_return({'new_configuration' => 'values'})


        env = {
            'USE_P_CONFIG_SERVER_SERVICE' => 'true',
            'CONFIG_SERVER_BRANCH' => 'branch',
            'VCAP_SERVICES' => vcap_services.to_json
        }

        expect {
        configurer.configure(app_name: 'test', rails_env: 'migration', env: env)
        }.to raise_error(RuntimeError)

      end

      it 'spring profiles active stuff' do

      end
    end

    context 'when CONFIG_SERVER_URL is nil or empty' do
      it 'should not fetch configuration' do
        allow(basic_auth_fetcher).to receive(:fetch_configuration) { fail("don't do it") }
        allow(oauth_fetcher).to receive(:fetch_configuration) { fail("don't do it") }

        configurer.configure(app_name: 'test',
                             rails_env: 'migration',
                             env: {
                                 'CONFIG_SERVER_URL' => '',
                                 'CONFIG_SERVER_BRANCH' => 'master',
                                 'CONFIG_SERVER_USERNAME' => 'user',
                                 'CONFIG_SERVER_PASSWORD' => 'pass',
                                 'CONFIG_SERVER_PROFILE_ACTIVE' => 'foo,bar'
                             }
        )

        configurer.configure(app_name: 'test',
                             rails_env: 'migration',
                             env: {
                                 'CONFIG_SERVER_BRANCH' => 'master',
                                 'CONFIG_SERVER_USERNAME' => 'user',
                                 'CONFIG_SERVER_PASSWORD' => 'pass',
                                 'CONFIG_SERVER_PROFILE_ACTIVE' => 'foo,bar'
                             }
        )

        expect(basic_auth_fetcher).not_to have_received(:fetch_configuration)
        expect(oauth_fetcher).not_to have_received(:fetch_configuration)
      end
    end

    context 'when USE_P_CONFIG_SERVER_SERVICE is not true and CONFIG_SERVER_URL is set' do
      it 'should use a BasicAuthConfigurationFetcher to update the env' do
        allow(basic_auth_fetcher).to receive(:fetch_configuration)
                                         .with('http://config.server', 'poop', 'staging', 'master', 'user', 'pass')
                                         .and_return({'new_configuration' => 'values'})

        env = {
            'USE_P_CONFIG_SERVER_SERVICE' => 'false',
            'CONFIG_SERVER_URL' => 'http://config.server',
            'CONFIG_SERVER_BRANCH' => 'master',
            'CONFIG_SERVER_USERNAME' => 'user',
            'CONFIG_SERVER_PASSWORD' => 'pass'
        }

        configurer.configure(app_name: 'poop',
                             rails_env: 'staging',
                             env: env
        )

        expect(env).to eq(
                           {
                               'USE_P_CONFIG_SERVER_SERVICE' => 'false',
                               'CONFIG_SERVER_URL' => 'http://config.server',
                               'CONFIG_SERVER_BRANCH' => 'master',
                               'CONFIG_SERVER_USERNAME' => 'user',
                               'CONFIG_SERVER_PASSWORD' => 'pass',
                               'new_configuration' => 'values'
                           }
                       )
      end
    end

    it 'should use CONFIG_SERVER_PROFILE_ACTIVE profiles instead of the Rails env if present' do
      allow(basic_auth_fetcher).to receive(:fetch_configuration).and_return({})

      configurer.configure(app_name: 'poop',
                           rails_env: 'staging',
                           env: {
                               'CONFIG_SERVER_URL' => 'http://config.server',
                               'CONFIG_SERVER_BRANCH' => 'master',
                               'CONFIG_SERVER_USERNAME' => 'user',
                               'CONFIG_SERVER_PASSWORD' => 'pass',
                               'CONFIG_SERVER_PROFILE_ACTIVE' => 'foo,bar'
                           }
      )

      expect(basic_auth_fetcher).to have_received(:fetch_configuration).with('http://config.server', 'poop', 'foo,bar', 'master', 'user', 'pass')
    end
  end
end