module Api
  class BaseController < ActionController::API
    clear_respond_to
    respond_to :json

    before_action :doorkeeper_authorize!
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: errors(error.message),
             status: :not_found
    end

    private

    def authenticate_admin!
      authenticate! { current_user && current_user.admin? }
    end

    def authenticate_user!
      authenticate! { current_user }
    end

    def authenticate!
      if doorkeeper_token
        user_id = doorkeeper_token.resource_owner_id
        Thread.current[:current_user] = User.find(user_id)
      end

      found = yield

      return if found

      render_unauthorized
    end

    def render_unauthorized
      render json: errors('Not getting in...'),
             status: :unauthorized
    end

    def current_user
      Thread.current[:current_user]
    end

    def errors(messages)
      { errors: [*messages] }
    end
  end
end
