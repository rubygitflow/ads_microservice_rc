# frozen_string_literal: true
module Concerns
  module PaginationLinks
    def pagination_links(scope)
      # https://github.com/jeremyevans/sequel/blob/master/lib/sequel/extensions/pagination.rb
      return {} if scope.pagination_record_count.zero?

      links = {
        first: pagination_link(page: 1),
        last: pagination_link(page: scope.page_count)
      }

      links[:next] = pagination_link(page: scope.next_page) unless scope.next_page.nil?
      links[:prev] = pagination_link(page: scope.prev_page) unless scope.prev_page.nil?

      links
    end

    private

    def pagination_link(page:)
      qs = Rack::Utils.build_query(request.GET.merge('page' => page))
      [request.path, qs].join('?')
    end
  end
end
