# frozen_string_literal: true

module Harvest
  class HTTPClient
    def initialize(domain:, account_id:, personal_token:, admin_api: false)
      @client = RestClient::Resource.new(
        domain.chomp('/') + '/api/v2',
        { headers: headers(personal_token, account_id) }
      )
    end

    # Make a api call to an endpoint.
    # @api public
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def api_call(path, http_method: 'get', param: nil, payload: nil, headers: nil)
      # RestClient::Request.process_url_params is looking for query params in the headers obj,
      headers ||= {}
      headers['params'] = param
      case http_method
      when 'get'
        http_resp = @client[path].get(headers)
        JSON.parse(http_resp)
      when 'post'
        @client[path].post(payload, headers)
      end
    end

    # Pagination through request
    # @api public
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def pagination(path, data_key, http_method: 'get', page_count: 1, param: nil, payload: nil, entries: nil)
      # TODO: tail call optimization
      param ||= {}
      entries ||= []

      param[:page] = page_count

      page = api_call(path, http_method: http_method, param: param, payload: payload)
      entries.concat(page[data_key])

      return entries if page_count >= page['total_pages']

      pagination(
        path,
        data_key,
        http_method: http_method,
        page_count: page_count + 1,
        param: param,
        payload: payload,
        entries: entries
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
end
