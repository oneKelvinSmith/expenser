module Api
  class SignupController < Api::BaseController
    skip_before_action :doorkeeper_authorize!
    skip_before_action :authenticate_user!

    def register
      user = User.new(signup_params)

      if user.save
        render json: user, status: :created, adapter: :json
      else
        render json: errors(user.errors), status: :unprocessable_entity
      end
    end

    private

    def signup_params
      p = params.permit(:email, :password, :password_confirmation)
      p.tap { p[:password_confirmation] ||= '' }
    end
  end
end
