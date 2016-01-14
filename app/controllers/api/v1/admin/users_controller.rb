module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        before_action :set_user, only: [:show, :update, :destroy]

        # GET /api/v1/admin/users
        # GET /api/v1/admin/users.json
        def index
          @users = User.all

          render json: @users
        end

        # GET /api/v1/admin/users/1
        # GET /api/v1/admin/users/1.json
        def show
          render json: @user
        end

        # POST /api/v1/admin/users
        # POST /api/v1/admin/users.json
        def create
          @user = User.new(create_params)

          if @user.save
            render json: @user, status: :created
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /api/v1/admin/users/1
        # PATCH/PUT /api/v1/admin/users/1.json
        def update
          if @user.update(user_params)
            head :no_content
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/users/1
        # DELETE /api/v1/admin/users/1.json
        def destroy
          @user.destroy

          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:email, :name)
        end

        def create_params
          params
            .require(:user)
            .permit(:email, :name, :password, :password_confirmation)
        end
      end
    end
  end
end
