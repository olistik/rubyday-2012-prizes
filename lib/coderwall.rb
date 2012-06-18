require 'faraday'
require 'json'
require 'pry'

module Coderwall
  module API
    DOMAIN = 'http://coderwall.com'

    class BadgesCount
      def initialize(username)
        @username = username
      end

      def value
        @value ||= fetch
      end

      def self.build_from_profile_url(url)
        new(url.split('/').last)
      end

      private
      def fetch
        response = JSON.parse(Faraday.get(api_url).body)
        value_from_response(response)
      end

      def value_from_response(response)
        response['badges'].count
      end

      def api_url
        "#{DOMAIN}/#{@username}.json"
      end
    end
  end
end
