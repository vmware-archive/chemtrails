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

When your Rails app boots, it will fetch the configuration for the given environment from the config server and populate
the ENV with the values it finds. It will use the application name and environment name to determine which set of values
to fetch. For example, if the application is named `Sandwich` and is running in the `production` environment, it will fetch
the configuration from the endpoint `$CONFIG_SERVER_URL/sandwich/production`. With Spring Cloud Config, this corresponds
to a property source named `sandwich-production.properties`.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
