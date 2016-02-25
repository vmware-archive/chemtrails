require 'rails'

module Spring
  module Cloud
    module Config
      module Rails
        class Railtie < ::Rails::Railtie
          config.before_configuration { startup }

          def self.startup
            server = ENV['SPRING_CONFIG_SERVER_URL']
            puts "Fetching application configuration from #{server}"
            fetcher = Spring::Cloud::Config::Rails::Fetcher.new(server, app_name, app_environment)
            ENV.update(fetcher.fetch_configuration)
          end

          private

          def self.app_name
            ::Rails.application.class.parent.to_s.downcase
          end

          def self.app_environment
            ::Rails.env
          end
        end
      end
    end
  end
end
