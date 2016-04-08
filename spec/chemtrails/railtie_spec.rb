require 'spec_helper'

describe Chemtrails::Railtie do
  describe 'initialize hooks' do
    let(:before_initialize_hooks) { ActiveSupport.instance_variable_get(:@load_hooks)[:before_initialize] }
    let(:before_initialize_hook_proc) { before_initialize_hooks.first.first }

    before { allow(Chemtrails::Railtie).to receive(:startup) }

    it 'registers an on load hook with ActiveSupport' do
      expect(before_initialize_hooks.length).to eq(1)
    end

    context 'when run in the test environment' do
      it 'does not call startup via ActiveSupport' do
        allow(Rails.env).to receive(:test?).and_return(true)

        before_initialize_hook_proc.call

        expect(Chemtrails::Railtie).to_not have_received(:startup)
      end
    end

    context 'when run in a non-test environment' do
      it 'does calls startup via ActiveSupport' do
        allow(Rails.env).to receive(:test?).and_return(false)

        before_initialize_hook_proc.call

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
      described_class.startup
      expect(ENV.fetch('foo')).to eq('bar')
    end
  end
end
