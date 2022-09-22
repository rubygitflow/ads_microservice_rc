class AdsMicroservice
  hash_path("/api/v1/ads") do |r|
    r.is do
      r.get do
        # ads = Ad.order(updated_at: :desc).page(params[:page])
        # serializer = AdSerializer.new(ads, links: pagination_links(ads))

        # render json: serializer.serialized_json
        []
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
        []
      end
    end
  end

  private

  # def pagination_links(scope)
  #   return {} if scope.total_pages.zero?

  #   links = {
  #     first: pagination_link(page: 1),
  #     last: pagination_link(page: scope.total_pages)
  #   }

  #   links[:next] = pagination_link(page: scope.next_page) if scope.next_page.present?
  #   links[:prev] = pagination_link(page: scope.prev_page) if scope.prev_page.present?

  #   links
  # end

  # def pagination_link(page:)
  #   url_for(request.query_parameters.merge(only_path: true, page: page))
  # end
end
