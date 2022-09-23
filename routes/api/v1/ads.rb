# frozen_string_literal: true
class AdsMicroservice
  include Concerns::PaginationLinks

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
        # result = Ads::CreateService.call(
        #   ad: ad_params,
        #   user: current_user
        # )

        # if result.success?
        #   serializer = AdSerializer.new(result.ad)
        #   render json: serializer.serialized_json, status: :created
        # else
        #   error_response(result.ad, :unprocessable_entity)
        # end
        {}
      end
    end
  end
end
