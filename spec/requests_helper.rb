require 'rails_helper'

module Requests
  module JsonHelpers
    def body
      JSON.parse(response.body)
    end

    def header
      response.header
    end

    def status
      response.status
    end
  end

  module AuthHelpers
    def user_params(hash)
      { user: hash }.to_json
    end

    def access_token(user)
      application = Doorkeeper::Application
                    .create(name: 'Client', redirect_uri: 'https://example.com')

      Doorkeeper::AccessToken
        .create(application: application, resource_owner_id: user.id)
        .token
    end

    def auth_headers(user)
      {
        'Content-Type'  => 'application/json', 'Accept' => 'application/json',
        'Authorization' => "Bearer #{access_token(user)}",
        'User-Agent'    => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) '\
                           'AppleWebKit/536.5 (KHTML, like Gecko) '\
                           'Chrome/19.0.1084.56 Safari/536.5',
        'X-API-Version' => '0.0.1',
        'X-API-Client'  => 'ExampleApp/TestSuite 0.0.1',
        'X-API-Device'  => 'iPhone 5,1 (iOS 8.1.3)'
      }
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
  config.include Requests::AuthHelpers, type: :request
end
