require_relative 'models'

require 'roda'
require 'json'

class AdsMicroservice < Roda
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

  plugin :sessions,
    key: '_AdsMicroservice.session',
    #cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
    secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'ADS_MICROSERVICE_SESSION_SECRET')

  Unreloader.require('routes', :delete_hook=>proc{|f| hash_branch(File.basename(f).delete_suffix('.rb'))}){}

  plugin :not_found do
    []
  end


  route do |r|
    r.hash_routes
  end
end

