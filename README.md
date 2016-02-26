# Chemtrails

[![Build Status](https://travis-ci.com/pivotal/chemtrails.svg?token=GqmN5yv6TyjxnxsoFgEG&branch=master)](https://travis-ci.com/pivotal/chemtrails)
[![Code Climate](https://codeclimate.com/github/pivotal/chemtrails/badges/gpa.svg)](https://codeclimate.com/github/pivotal/chemtrails)
[![Test Coverage](https://codeclimate.com/github/pivotal/chemtrails/badges/coverage.svg)](https://codeclimate.com/github/pivotal/chemtrails/coverage)

This gem allows you to fetch the configuration for your rails app from a [Spring Cloud Config](http://cloud.spring.io/spring-cloud-config) server. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chemtrails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chemtrails

## Usage

Set the location of your config server in the environment:

```
CONFIG_SERVER_URL=http://localhost:8080
CONFIG_SERVER_USERNAME=username
CONFIG_SERVER_PASSWORD=password
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
