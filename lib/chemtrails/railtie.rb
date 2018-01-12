require 'rails'
require 'chemtrails/configurer'

module Chemtrails
  class Railtie < Rails::Railtie
    config.before_configuration do
      startup(Rails.application.class.parent.to_s.downcase, Rails.env, ENV) unless Rails.env.test?
    end

    def self.startup(app_name, rails_env, env)
      Chemtrails::Configurer.new.configure(app_name: app_name, rails_env: rails_env, env: env)
    end
  end
end
