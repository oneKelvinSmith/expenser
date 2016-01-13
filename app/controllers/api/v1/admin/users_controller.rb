module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        def index
          @users = User.all

          render json: @users
        end

        def show
          @user = User.find params[:id]

          render json: @user
        end
      end
    end
  end
end
