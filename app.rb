# frozen_string_literal: true
require_relative 'models'

require 'roda'
require 'json'

require 'i18n'
I18n.load_path << Dir[File.expand_path("config/locales/api") + "/*.yml"]
I18n.default_locale = :ru # (note that `en` is already the default!)

class AdsMicroservice < Roda
  # https://github.com/jeremyevans/rack-unreloader#classes-split-into-multiple-files-
  Unreloader.require 'serializers'

  plugin :hash_routes
  plugin :typecast_params
  plugin :json

  plugin :default_headers,
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'Content-Type'=>'application/json'

  logger = if ENV['RACK_ENV'] == 'test'
    Class.new{def write(_) end}.new
  else
    $stderr
  end
  plugin :common_logger, logger

  plugin :not_found do
    {}
  end
  
  # https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/ErrorHandler.html
  plugin :error_handler do |e|
    case e
    # https://www.rubydoc.info/gems/sequel/4.8.0/Sequel 
    # https://sequel.jeremyevans.net/rdoc/
    when Sequel::NoMatchingRow 
      response.status = 404
      error_response e.message, meta: {'meta' => ::I18n.t(:not_found, scope: 'api.errors')}
    when Sequel::UniqueConstraintViolation 
      response.status = 422
      error_response e.message, meta: {'meta' => ::I18n.t(:not_unique, scope: 'api.errors')}
    when Roda::RodaPlugins::TypecastParams::Error 
      response.status = 422
      error_response e.message, meta: {'meta' => ::I18n.t(:missing_parameters, scope: 'api.errors')}
    when KeyError 
      response.status = 422
      error_response e.message, meta: {'meta' => ::I18n.t(:missing_parameters, scope: 'api.errors')}
    else
      response.status = 500
      error_response e.message, meta: {'meta' => e.class }
    end
  end 

  plugin :sessions,
    key: '_AdsMicroservice.session',
    secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'ADS_MICROSERVICE_SESSION_SECRET')

  Unreloader.require('routes', :delete_hook=>proc{|f| hash_branch(File.basename(f).delete_suffix('.rb'))}){}

  route do |r|
    r.hash_routes
  end
end
