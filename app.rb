require_relative 'models'

require 'roda'
# require 'tilt/sass'

# class V1 < Roda
#   include PaginationLinks

#   plugin :typecast_params

#   hash_path("/api/v1/ads") do |r|
#     # /api/v1/ads path
#     r.is do
#       r.get do
#         ads = Ad.order(updated_at: :desc).page(params[:page])
#         serializer = AdSerializer.new(ads, links: pagination_links(ads))

#         render json: serializer.serialized_json
#       end

#       r.post do
#         result = Ads::CreateService.call(
#           ad: ad_params,
#           user: current_user
#         )

#         if result.success?
#           serializer = AdSerializer.new(result.ad)
#           render json: serializer.serialized_json, status: :created
#         else
#           error_response(result.ad, :unprocessable_entity)
#         end
#       end
#     end
#   end

#   # route do |r|
#   #   r.on "ads" do
#   #     r.is do
#   #       r.get do
#   #         ads = Ad.order(updated_at: :desc).page(params[:page])
#   #         serializer = AdSerializer.new(ads, links: pagination_links(ads))

#   #         render json: serializer.serialized_json
#   #       end

#   #       r.post do
#   #         result = Ads::CreateService.call(
#   #           ad: ad_params,
#   #           user: current_user
#   #         )

#   #         if result.success?
#   #           serializer = AdSerializer.new(result.ad)
#   #           render json: serializer.serialized_json, status: :created
#   #         else
#   #           error_response(result.ad, :unprocessable_entity)
#   #         end
#   #       end
#   #     end
#   #   end
#   # end
# end


# class API < Roda
#   route do |r|
#     r.on "v1" do
#       r.run V1
#     end
#   end
# end

class AdsMicroservice < Roda
  plugin :hash_routes
  plugin :typecast_params


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

  route do |r|
    r.hash_routes
    # r.on "api" do
    #   r.run API
    # end
  end
end


# class AdsMicroservice < Roda
#   opts[:check_dynamic_arity] = false
#   opts[:check_arity] = :warn

#   plugin :default_headers,
#     'Content-Type'=>'text/html',
#     #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
#     'X-Frame-Options'=>'deny',
#     'X-Content-Type-Options'=>'nosniff',
#     'X-XSS-Protection'=>'1; mode=block'

#   plugin :content_security_policy do |csp|
#     csp.default_src :none
#     csp.style_src :self, 'https://maxcdn.bootstrapcdn.com'
#     csp.form_action :self
#     csp.script_src :self
#     csp.connect_src :self
#     csp.base_uri :none
#     csp.frame_ancestors :none
#   end

#   plugin :route_csrf
#   plugin :flash
#   plugin :assets, css: 'app.scss', css_opts: {style: :compressed, cache: false}, timestamp_paths: true
#   plugin :render, escape: true, layout: './layout'
#   plugin :public
#   plugin :hash_branch_view_subdir

#   logger = if ENV['RACK_ENV'] == 'test'
#     Class.new{def write(_) end}.new
#   else
#     $stderr
#   end
#   plugin :common_logger, logger

#   plugin :not_found do
#     @page_title = "File Not Found"
#     view(:content=>"")
#   end

#   if ENV['RACK_ENV'] == 'development'
#     plugin :exception_page
#     class RodaRequest
#       def assets
#         exception_page_assets
#         super
#       end
#     end
#   else
#     def self.freeze
#       Sequel::Model.freeze_descendents
#       DB.freeze
#       super
#     end
#   end

#   plugin :error_handler do |e|
#     case e
#     when Roda::RodaPlugins::RouteCsrf::InvalidToken
#       @page_title = "Invalid Security Token"
#       response.status = 400
#       view(:content=>"<p>An invalid security token was submitted with this request, and this request could not be processed.</p>")
#     else
#       $stderr.print "#{e.class}: #{e.message}\n"
#       $stderr.puts e.backtrace
#       next exception_page(e, :assets=>true) if ENV['RACK_ENV'] == 'development'
#       @page_title = "Internal Server Error"
#       view(:content=>"")
#     end
#   end

#   plugin :sessions,
#     key: '_AdsMicroservice.session',
#     #cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
#     secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'ADS_MICROSERVICE_SESSION_SECRET')

#   Unreloader.require('routes', :delete_hook=>proc{|f| hash_branch(File.basename(f).delete_suffix('.rb'))}){}

#   route do |r|
#     r.public
#     r.assets
#     check_csrf!

#     r.hash_branches('')

#     r.root do
#       view 'index'
#     end
#   end
# end
