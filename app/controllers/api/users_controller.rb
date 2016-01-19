module Api
  class UsersController < Api::BaseController
    skip_before_action :authenticate_user!, except: [:current]
    before_action :authenticate_admin!, except: [:current]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all

      render json: @users
    end

    def show
      render json: @user
    end

    def create
      generated_password = Devise.friendly_token.first(8)
      @user = User.new(user_params.merge(password: generated_password))

      if @user.save
        render json: @user, status: :created
      else
        render json: errors_json, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        head :no_content
      else
        render json: errors_json, status: :unprocessable_entity
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

    def errors_json
      {
        errors: @user.errors
      }
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :admin)
    end
  end
end
