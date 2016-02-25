require 'json'

module Spring
  module Cloud
    module Config
      module Rails
        class Fetcher
          def initialize(url, application, environment)
            @url = url
            @application = application
            @environment = environment
          end

          def fetch_configuration
            uri = URI("#{@url}/#{@application}/#{@environment}")
            response = Net::HTTP.get_response(uri)

            if success?(response)
              json = JSON.parse(response.body)
              {}.tap do |props|
                sources = json['propertySources']
                sources.each { |source| props.reverse_merge!(source['source']) }
              end
            else
              raise RuntimeError.new("Error fetching configuration from: #{@url}")
            end
          end

          private

          def success?(response)
            response.code.to_i >= 200 && response.code.to_i < 400
          end
        end
      end
    end
  end
end
