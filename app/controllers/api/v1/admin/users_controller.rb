module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        # GET /api/v1/admin/users
        # GET /api/v1/admin/users.json
        def index
          @users = User.all

          render json: @users
        end

        # GET /api/v1/admin/users/1
        # GET /api/v1/admin/users/1.json
        def show
          @user = User.find params[:id]

          render json: @user
        end

        # PATCH/PUT /api/v1/admin/users/1
        # PATCH/PUT /api/v1/admin/users/1.json
        def update
          @user = User.find params[:id]

          if @user.update(user_params)
            head :no_content
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        private

        def user_params
          params.require(:user).permit(:email, :name)
        end
      end
    end
  end
end
