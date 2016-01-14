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
        return if current_user.try(:admin?)
        render json: {
          errors: ['Authorized users only.']
        }, status: :unauthorized
      end
    end
  end
end
