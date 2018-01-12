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
end
