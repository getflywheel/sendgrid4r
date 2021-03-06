# -*- encoding: utf-8 -*-

module SendGrid4r
  module REST
    #
    # SendGrid Web API v3 ApiKeys
    #
    module ApiKeys
      include SendGrid4r::REST::Request

      ApiKeys = Struct.new(:result)
      ApiKey = Struct.new(:name, :api_key_id, :api_key, :scopes)

      def self.url(api_key_id = nil)
        url = "#{BASE_URL}/api_keys"
        url = "#{url}/#{api_key_id}" unless api_key_id.nil?
        url
      end

      def self.create_api_keys(resp)
        return resp if resp.nil?
        api_keys = []
        resp['result'].each do |api_key|
          api_keys.push(SendGrid4r::REST::ApiKeys.create_api_key(api_key))
        end
        ApiKeys.new(api_keys)
      end

      def self.create_api_key(resp)
        return resp if resp.nil?
        ApiKey.new(
          resp['name'],
          resp['api_key_id'],
          resp['api_key'],
          resp['scopes']
        )
      end

      def get_api_keys(&block)
        resp = get(@auth, SendGrid4r::REST::ApiKeys.url, &block)
        SendGrid4r::REST::ApiKeys.create_api_keys(resp)
      end

      def post_api_key(name:, scopes: nil, &block)
        params = {}
        params['name'] = name
        params['scopes'] = scopes unless scopes.nil?
        resp = post(@auth, SendGrid4r::REST::ApiKeys.url, params, &block)
        SendGrid4r::REST::ApiKeys.create_api_key(resp)
      end

      def get_api_key(api_key_id:, &block)
        endpoint = SendGrid4r::REST::ApiKeys.url(api_key_id)
        resp = get(@auth, endpoint, &block)
        SendGrid4r::REST::ApiKeys.create_api_key(resp)
      end

      def delete_api_key(api_key_id:, &block)
        delete(@auth, SendGrid4r::REST::ApiKeys.url(api_key_id), &block)
      end

      def patch_api_key(api_key_id:, name:, &block)
        params = {}
        params['name'] = name
        endpoint = SendGrid4r::REST::ApiKeys.url(api_key_id)
        resp = patch(@auth, endpoint, params, &block)
        SendGrid4r::REST::ApiKeys.create_api_key(resp)
      end

      def put_api_key(api_key_id:, name:, scopes:, &block)
        params = {}
        params['name'] = name unless name.nil?
        params['scopes'] = scopes unless scopes.nil?
        endpoint = SendGrid4r::REST::ApiKeys.url(api_key_id)
        resp = put(@auth, endpoint, params, &block)
        SendGrid4r::REST::ApiKeys.create_api_key(resp)
      end
    end
  end
end
