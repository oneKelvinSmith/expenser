module Api
  module V1
    class BaseController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken

      protected

      def current_user
        current_api_v1_user
      end

      def authenticate_user!
        authenticate_api_v1_user!
      end

      def authenticate_admin!
        authenticate_user! && current_user.admin?
      end
    end
  end
end
