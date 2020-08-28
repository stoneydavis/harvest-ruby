# frozen_string_literal: true

module Harvest
  module HTTP
    class Client
      def initialize(domain:, account_id:, personal_token:, admin_api: false)
        @client = RestClient::Resource.new(
          domain.chomp('/') + '/api/v2',
          { headers: headers(personal_token, account_id) }
        )
      end

      # Make a api call to an endpoint.
      # @api public
      # @param struct [Harvest::ApiCall]
      def api_call(struct)
        struct.headers['params'] = struct.param
        case struct.http_method
        when 'get'
          http_resp = @client[struct.path].get(struct.headers)
          JSON.parse(http_resp)
        when 'post'
          @client[struct.path].post(struct.payload, struct.headers)
        end

      end

      # Pagination through request
      # @api public
      # @param struct [Harvest::Pagination]
      def pagination(struct)
        struct.param[:page] = struct.page_count
        page = api_call(struct.to_api_call)
        struct.entries.concat(page[struct.data_key])

        return struct.entries if struct.page_count >= page['total_pages']

        struct.page_count += 1
        pagination(struct)
      end

      # Create Paginaation struct message to pass to pagination call
      def paginator(http_method: 'get', page_count: 1, param: nil, entries: nil, headers: nil)
        headers ||= {}
        param ||= {}
        entries ||= []
        Harvest::HTTP::Pagination.new(
          {
            http_method: http_method,
            param: param,
            entries: entries,
            page_count: page_count,
            headers: headers
          }
        )
      end

      def api_caller(path, http_method: 'get', param: nil, payload: nil, headers: nil)
        headers ||= {}
        param ||= {}
        Harvest::HTTP::ApiCall.new(
          {
            path: path,
            http_method: http_method,
            param: param,
            payload: payload,
            headers: headers
          }
        )
      end

      private

      # @api private
      def headers(personal_token, account_id)
        {
          'User-Agent' => 'Ruby Harvest API Sample',
          'Authorization' => "Bearer #{personal_token}",
          'Harvest-Account-ID' => account_id
        }
      end
    end

    ApiCall = Struct.new(
      :path,
      :http_method,
      :param,
      :payload,
      :headers,
      keyword_init: true
    )

    Pagination = Struct.new(
      :path,
      :data_key,
      :http_method,
      :page_count,
      :param,
      :payload,
      :entries,
      :headers,
      keyword_init: true
    ) do
      def to_api_call
        ApiCall.new(
          {
            path: path,
            http_method: http_method,
            param: param,
            payload: payload,
            headers: headers
          }
        )
      end

      def increment_page
        self.page_count += 1
        self
      end
    end
  end
end
