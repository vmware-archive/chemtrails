require 'spec_helper'

describe Spring::Cloud::Config::Rails::Fetcher do
  subject { Spring::Cloud::Config::Rails::Fetcher.new('http://example.com', 'foo', 'development') }

  describe '#fetch_configuration' do
    before do
      stub_request(:get, 'http://example.com/foo/development').to_return(body: JSON.generate(
        propertySources: [
          {
            name: 'file:/some/file/path/foo-development.properties',
            source: {
              SOME_SETTING_1: 'foo'
            }
          },
          {
            name: 'file:/some/file/path/foo.properties',
            source: {
              SOME_SETTING_1: 'bar',
              SOME_SETTING_2: 'baz',
            }
          }
        ]
      ))
    end

    it 'should fetch configuration from the config server' do
      subject.fetch_configuration
      expect(WebMock).to have_requested(:get, 'http://example.com/foo/development')
    end

    it 'should return the configuration values' do
      values = subject.fetch_configuration
      expect(values['SOME_SETTING_2']).to eq('baz')
    end

    it 'should override values with more specific values' do
      values = subject.fetch_configuration
      expect(values['SOME_SETTING_1']).to eq('foo')
    end

    context 'when the fetch fails' do
      before do
        stub_request(:get, 'http://example.com/foo/development').to_return(status: 500)
      end

      it 'should raise a RuntimeError' do
        expect {
          subject.fetch_configuration
        }.to raise_error(RuntimeError)
      end
    end
  end
end
