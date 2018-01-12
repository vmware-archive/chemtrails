require 'spec_helper'

describe Chemtrails::Configurer do
  describe '#configure' do
    let(:fetcher) {double(fetch_configuration: {'foo' => 'bar'})}
    let(:configurer) {Chemtrails::Configurer.new}

    before do
      allow(Chemtrails::Fetcher).to receive(:new).and_return(fetcher)
    end

    it 'should update the environment with the configuration values' do
      env = {
          'CONFIG_SERVER_URL' => 'pls.load.my.config.io'
      }
      configurer.configure(app_name: 'app', rails_env: 'env', env: env)
      expect(env.fetch('foo')).to eq('bar')
    end

    it 'should pass the correct environment variables to the fetcher' do
      configurer.configure(app_name: 'poop',
                           rails_env: 'staging',
                           env:
                               {
                                   'CONFIG_SERVER_URL' => 'http://config.server',
                                   'CONFIG_SERVER_BRANCH' => 'master',
                                   'CONFIG_SERVER_USERNAME' => 'user',
                                   'CONFIG_SERVER_PASSWORD' => 'pass'
                               }
      )

      expect(Chemtrails::Fetcher).to have_received(:new).with('http://config.server', 'poop', 'staging', 'master', 'user', 'pass')
    end

    it 'should use CONFIG_SERVER_PROFILE_ACTIVE profiles instead of the Rails env if present' do
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

      expect(Chemtrails::Fetcher).to have_received(:new).with('http://config.server', 'poop', 'foo,bar', 'master', 'user', 'pass')
    end

    it 'should not fetch configuration if CONFIG_SERVER_URL is nil or empty' do
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

      expect(Chemtrails::Fetcher).not_to have_received(:new)
    end
  end
end