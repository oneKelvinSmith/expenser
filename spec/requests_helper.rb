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
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
end
