require 'faraday'
require 'json'

module StackOverflow
  module API
    DOMAIN = 'http://api.stackexchange.com'

    class Reputation
      def initialize(user_id)
        @user_id = user_id
      end

      def value
        @value ||= fetch
      end

      def self.build_from_profile_url(url)
        new(url.split('/')[-2])
      end

      private
      def fetch
        response = JSON.parse(Faraday.get(api_url).body)
        value_from_response(response)
      end

      def value_from_response(response)
        response['items'].first['reputation']
      end

      def api_url
        "#{::StackOverflow::API::DOMAIN}/2.0/users/#{@user_id}?order=desc&sort=reputation&site=stackoverflow"
      end
    end
  end
end
