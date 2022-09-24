# frozen_string_literal: true
require_relative 'concerns/pagination_links'
require_relative 'concerns/validations'
require_relative 'concerns/api_errors'
require_relative 'concerns/api_errors'
require './contract/ad_params_contract'
require './serializers/error_serializer'
require './services/ads/create_service'

class AdsMicroservice
  include Concerns::PaginationLinks
  include Concerns::Validations
  include Concerns::ApiErrors

  PAGE_FIRST = 1
  PAGE_SIZE = 20

  hash_path("/api/v1/ads") do |r|
    r.is do
      r.get do
        # https://stackoverflow.com/questions/16937731/sinatra-kaminari-pagination-problems-with-sequel-and-postgres
        page = Integer(r.params[:page]) rescue PAGE_FIRST
        # hhttps://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html
        ads = Ad.order(Sequel.desc(:updated_at))
          .select(:title, :description, :city, :user_id, :lat, :lon)
          .paginate(page, PAGE_SIZE)

        {data: ads.all, links: pagination_links(ads)}
     end

      r.post do
        ad_params = validate_with!(::AdParamsContract)

        result = Ads::CreateService.call(
          ad: ad_params[:ad]
        )

        if result.success?
          response.status = 201
          {data: result.ad}
        else
          response.status = 422
          error_response(result.ad)
        end
      end
    end
  end
end
