require 'spec_helper'

describe Chemtrails::Railtie do
  describe 'initialize hooks' do
    let(:before_configuration_hooks) { ActiveSupport.instance_variable_get(:@load_hooks)[:before_configuration] }
    let(:before_configuration_hook_proc) { before_configuration_hooks.first.first }

    before { allow(Chemtrails::Railtie).to receive(:startup) }

    it 'registers an on load hook with ActiveSupport' do
      expect(before_configuration_hooks.length).to eq(1)
    end

    context 'when run in the test environment' do
      it 'does not call startup via ActiveSupport' do
        allow(Rails.env).to receive(:test?).and_return(true)

        before_configuration_hook_proc.call

        expect(Chemtrails::Railtie).to_not have_received(:startup)
      end
    end

    context 'when run in a non-test environment' do
      it 'does calls startup via ActiveSupport' do
        allow(Rails.env).to receive(:test?).and_return(false)

        before_configuration_hook_proc.call

        expect(Chemtrails::Railtie).to have_received(:startup)
      end
    end
  end

  describe '#startup' do
    let(:fetcher) { double(fetch_configuration: {'foo' => 'bar'}) }

    before do
      allow(Chemtrails::Fetcher).to receive(:new).and_return(fetcher)
    end

    it 'should update the environment with the configuration values' do
      env = {}
      described_class.startup('app', 'env', env)
      expect(env.fetch('foo')).to eq('bar')
    end

    it 'should pass the correct environment variables to the fetcher' do
      described_class.startup( 'poop', 'staging',
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
      described_class.startup( 'poop', 'staging',
                               {
                                   'CONFIG_SERVER_URL' => 'http://config.server',
                                   'CONFIG_SERVER_BRANCH' => 'master',
                                   'CONFIG_SERVER_USERNAME' => 'user',
                                   'CONFIG_SERVER_PASSWORD' => 'pass',
                                   'CONFIG_SERVER_PROFILE_ACTIVE' => 'foo,bar'
                               }
      )

      expect(Chemtrails::Fetcher).to have_received(:new).with('http://config.server', 'poop', 'foo,bar', 'master', 'user', 'pass')
    end
  end
end
