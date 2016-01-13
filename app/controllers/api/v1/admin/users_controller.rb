module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        def index
          @users = User.all

          render json: @users
        end
      end
    end
  end
end
