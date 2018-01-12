require 'spec_helper'

describe Chemtrails::ConfigurationFetcher do
  subject { Chemtrails::ConfigurationFetcher.new }

  describe '#fetch_configuration' do
    context 'when a branch name is provided' do
      context 'when the fetch is successful' do
        before do
          stub_request(:get, 'http://example.com/foo/development/production').to_return(body: JSON.generate(
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

        it 'should fetch configuration from the config server with basic auth' do
          subject.fetch_configuration('http://example.com', 'foo', 'development', 'production', 'Bearer token')
          expect(WebMock).to have_requested(:get, 'http://example.com/foo/development/production').with(headers: {'Authorization' => 'Bearer token'})
        end

        it 'should return the configuration values' do
          values = subject.fetch_configuration('http://example.com', 'foo', 'development', 'production', 'Bearer token')
          expect(values['SOME_SETTING_2']).to eq('baz')
        end

        it 'should override values with more specific values' do
          values = subject.fetch_configuration('http://example.com', 'foo', 'development', 'production', 'Bearer token')
          expect(values['SOME_SETTING_1']).to eq('foo')
        end
      end

      context 'when the fetch is not successful' do
        before do
          stub_request(:get, 'http://example.com/foo/development/production').to_return(status: 500)
        end

        it 'should raise a RuntimeError' do
          expect {
            subject.fetch_configuration('http://example.com', 'foo', 'development', 'production', 'Bearer token')
          }.to raise_error(RuntimeError)
        end
      end
    end

    context 'when a branch name is not provided' do
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

      it 'should fetch configuration from the config server with basic auth' do
        subject.fetch_configuration('http://example.com', 'foo', 'development', nil, 'Bearer token')
        expect(WebMock).to have_requested(:get, 'http://example.com/foo/development').with(headers: {'Authorization' => 'Bearer token'})
      end
    end
  end
end
