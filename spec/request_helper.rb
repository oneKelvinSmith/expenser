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
