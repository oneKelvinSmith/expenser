module Api
  class UsersController < Api::BaseController
    skip_before_action :authenticate_user!, except: [:current]
    before_action :authenticate_admin!, except: [:current]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all

      render json: @users, adapter: :json
    end

    def show
      render json: @user, adapter: :json
    end

    def create
      @user = User.new(create_params)

      if @user.save
        render json: @user, status: :created, adapter: :json
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy

      head :no_content
    end

    def current
      @user = current_user

      render json: @user, adapter: :json
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :admin)
    end

    def create_params
      params
        .require(:user)
        .permit(:email, :password, :password_confirmation)
    end
  end
end
