# Chemtrails

[![Build Status](https://travis-ci.org/pivotal/chemtrails.svg?branch=master)](https://travis-ci.org/pivotal/chemtrails)
[![Code Climate](https://codeclimate.com/github/pivotal/chemtrails/badges/gpa.svg)](https://codeclimate.com/github/pivotal/chemtrails)
[![Test Coverage](https://codeclimate.com/github/pivotal/chemtrails/badges/coverage.svg)](https://codeclimate.com/github/pivotal/chemtrails/coverage)

This gem allows you to fetch the configuration for your rails app from a [Spring Cloud Config](http://cloud.spring.io/spring-cloud-config) server. 

## Installation

Add this line to your application's Gemfile:

    gem 'chemtrails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chemtrails

## Configuration

Set the location and of your config server and any necessary credentials in the environment:

    CONFIG_SERVER_URL=http://localhost:8080
    CONFIG_SERVER_USERNAME=username
    CONFIG_SERVER_PASSWORD=password
    
If you want to request values that are not on the `master` branch, you can optionally supply the branch name:

    CONFIG_SERVER_BRANCH=production

If this is not provided, Spring Cloud Config will return values from the `master` branch.

You will also need to set your Rails environment so that Chemtrails knows which profile to fetch properties for.

    RAILS_ENV={env}
    
If you'd like to fetch properties from a different profile (or multiple profiles) use `CONFIG_SERVER_PROFILE_ACTIVE` to override. e.g.

    CONFIG_SERVER_PROFILE_ACTIVE=staging,web,noclip,muted
    
When your Rails app boots, it will fetch the configuration for the given environment from the config server and populate
the ENV with the values it finds. It will use the application name and environment name to determine which set of values
to fetch. For example, if the application is named `Sandwich` and is running in the `production` environment, it will fetch
the configuration from the endpoint `$CONFIG_SERVER_URL/sandwich/production`. With Spring Cloud Config, this corresponds
to a property source named `sandwich-production.properties`.

## Disabling

If you do not provide a CONFIG_SERVER_URL then Chemtrails will not try to fetch variables from a config server.

## Releasing a new version
Increase the version number in `lib/chemtrails/version.rb`

    gem build chemtrails.gemspec
    gem push chemtrails-$VERSION.gem
    
Credentials are in lastpass
    

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
