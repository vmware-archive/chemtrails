require 'spec_helper'

describe Spring::Cloud::Config::Rails::Railtie do
  describe '.startup' do
    let(:fetcher) { double(fetch_configuration: {'foo' => 'bar'}) }

    before do
      allow(Spring::Cloud::Config::Rails::Fetcher).to receive(:new).and_return(fetcher)
    end

    it 'should update the environment with the configuration values' do
      described_class.startup
      expect(ENV.fetch('foo')).to eq('bar')
    end
  end
end
