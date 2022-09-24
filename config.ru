# frozen_string_literal: true
dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

require 'rack/unreloader' # https://github.com/jeremyevans/rack-unreloader
Unreloader = Rack::Unreloader.new(subclasses: %w'Roda Sequel::Model', logger: logger, reload: dev){AdsMicroservice}
require_relative 'models'
Unreloader.require('app.rb'){'AdsMicroservice'}
run(dev ? Unreloader : AdsMicroservice.freeze.app)

Unreloader.require 'contract'
Unreloader.require 'serializers'
Unreloader.require 'services'
