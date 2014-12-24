require 'expresspigeon-ruby/version'

require 'net/http'
require 'json'

module ExpressPigeon
  AUTH_KEY = -> { ENV['EXPRESSPIGEON_AUTH_KEY'] || fail('Provide EXPRESSPIGEON_AUTH_KEY or set ExpressPigeon::AUTH_KEY environment variable') }
  ROOT = 'https://api.expresspigeon.com/'.freeze
  USE_SSL = true
  module API
    def http(path, method, params = {})
      uri = URI.parse "#{ROOT}#{path}"
      req = Net::HTTP.const_get("#{method}").new "#{ROOT}#{path}"
      req['X-auth-key'] = AUTH_KEY
      if params
        req.body = params.to_json
        req['Content-type'] = 'application/json'
      end

      if block_given?
        Net::HTTP.start(uri.host, uri.port, use_ssl: USE_SSL) do |http|
          http.request req do |res|
            res.read_body do |seg|
              yield seg
            end
          end
        end
      else
        resp = Net::HTTP.start(uri.host, uri.port, use_ssl: USE_SSL) do |http|
          http.request req
        end
        parsed = JSON.parse(resp.body)
        if parsed.kind_of? Hash
          MetaHash.new parsed
        else
          parsed
        end
      end
    end

    def get(path, &block)
      http path, 'Get', nil, &block
    end

    def post(path, params = {})
      http path, 'Post', params
    end

    def del(path, params = {})
      http path, 'Delete', params
    end

    class << self
      def campaigns
        Campaigns.new
      end

      def lists
        Lists.new
      end

      def contacts
        Contacts.new
      end

      def messages
        Messages.new
      end
    end
  end
end

require 'expresspigeon-ruby/meta_hash'
require 'expresspigeon-ruby/contacts'
require 'expresspigeon-ruby/lists'
require 'expresspigeon-ruby/messages'
require 'expresspigeon-ruby/campaigns'
