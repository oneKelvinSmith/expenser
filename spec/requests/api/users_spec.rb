require 'requests_helper'

RSpec.describe 'Users', type: :request do
  def request_params(inner)
    { user: inner }.to_json
  end

  def user_params
    { email: 'user@example.com', password: 'password' }
  end

  def create_user(overrides = {})
    User.create user_params.merge(overrides)
  end

  context 'unauthorized user'do
    describe 'GET /users' do
      it 'responds with :unauthorized when user is not signed in' do
        get '/api/users'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = create_user

        get '/api/users', {}, auth_headers(user)

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'GET /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        get '/api/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = create_user

        get '/api/users/1', {}, auth_headers(user)

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'POST /users' do
      it 'responds with :unauthorized when user is not signed in' do
        post '/api/users'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = create_user

        post '/api/users', {}, auth_headers(user)

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'PATCH/PUT /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        put '/api/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = create_user

        put '/api/users/1', {}, auth_headers(user)

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'DELETE /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        delete '/api/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = create_user

        delete '/api/users/1', {}, auth_headers(user)

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  context 'authorized administrator' do
    let!(:admin) do
      create_user email: 'admin@example.com', admin: true
    end

    describe 'GET /users' do
      it 'returns a list of users' do
        user = create_user

        get '/api/users', {}, auth_headers(admin)

        expect(response).to have_http_status :ok

        expect(body['users'].count).to be 2
        expect(body['users']).to eq [user_json(admin),
                                     user_json(user)]
      end
    end

    describe 'GET /users/1' do
      it 'returns the specific user' do
        user = create_user

        get "/api/users/#{user.id}", {}, auth_headers(admin)

        expect(response).to have_http_status :ok

        expect(body['user']).to eq user_json(user)
      end

      it 'returns raises and error if the record isnot found' do
        get '/api/users/42', {}, auth_headers(admin)

        expect(response).to have_http_status :not_found
      end
    end

    describe 'POST /users' do
      it 'creates a new user' do
        email = 'new_user@example.com'
        params = request_params email: email, admin: true

        post '/api/users', params, auth_headers(admin)

        new_user = User.find_by email: email

        expect(new_user.email).to eq email
      end

      it 'generates a password for the new user' do
        allow(Devise).to receive(:friendly_token).and_return('password')
        params = request_params email: 'new_user@example.com', admin: true

        post '/api/users', params, auth_headers(admin)

        expect(Devise).to have_received(:friendly_token)
      end

      it 'creates a new admin' do
        email = 'new_email@example.com'
        params = request_params email: email, admin: true

        post '/api/users', params, auth_headers(admin)

        new_user = User.find_by email: email

        expect(new_user).to be_admin
      end

      it 'returns the created user' do
        email = 'new_user@example.com'
        params = request_params email: email

        post '/api/users', params, auth_headers(admin)

        new_user = User.find_by email: email

        expect(body['user']).to eq user_json(new_user)
      end

      it 'responds with :created on successful create' do
        params = request_params email: 'new_user@example.com'

        post '/api/users', params, auth_headers(admin)

        expect(response).to have_http_status :created
      end

      it 'responds with :unprocessable_entity when create fails' do
        params = {
          email: 'new_user@example.com', password: 'password'
        }

        request_params = request_params(params)

        new_user = User.new params

        allow(User).to receive(:new).and_return new_user
        allow(new_user).to receive(:save).and_return false

        post '/api/users', request_params, auth_headers(admin)

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when create fails' do
        params = {
          email: 'new_user@example.com', password: 'password'
        }

        request_params = request_params(params)

        new_user = User.new params

        new_user.errors.add('email', 'Email has been taken')

        allow(User).to receive(:new).and_return new_user
        allow(new_user).to receive(:save).and_return false

        post '/api/users', request_params, auth_headers(admin)

        expect(body['errors']['email']).to eq ['Email has been taken']
      end
    end

    describe 'PATCH/PUT /users/1 ' do
      it 'updates the specified user' do
        user = create_user email: 'user@example.com'

        params = request_params email: 'new_email@example.com'

        put "/api/users/#{user.id}", params, auth_headers(admin)

        user.reload

        expect(user.email).to eq 'new_email@example.com'
      end

      it 'responds with :no_content on successful update' do
        user = create_user

        params = request_params admin: true

        put "/api/users/#{user.id}", params, auth_headers(admin)

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'responds with :uprocessable_entity when update fails' do
        user = create_user

        params = request_params email: 'NOT AN EMAIL'

        put "/api/users/#{user.id}", params, auth_headers(admin)

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when update fails' do
        user = create_user

        params = request_params email: 'NOT AND EMAIL'

        put "/api/users/#{user.id}", params, auth_headers(admin)

        expect(body['errors']['email']).to eq ['is invalid']
      end

      it 'responds with :not_found if the record is not found' do
        put '/api/users/42', {}, auth_headers(admin)

        expect(response).to have_http_status :not_found
      end
    end

    describe 'DELETE /users/1' do
      it 'deletes the specified user' do
        user = create_user

        delete "/api/users/#{user.id}", {}, auth_headers(admin)

        expect do
          User.find user.id
        end.to raise_error ActiveRecord::RecordNotFound
      end

      it 'responds with :no_content on successful delete' do
        user = create_user

        delete "/api/users/#{user.id}", {}, auth_headers(admin)

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'returns raises and error if the record isnot found' do
        delete '/api/users/42', {}, auth_headers(admin)

        expect(response).to have_http_status :not_found
      end
    end
  end

  context 'current user' do
    describe 'GET /users/current' do
      it 'returns the currently authenticated user details' do
        user = User.create email: 'registered@example.com', password: 'password'

        get '/api/current_user', {}, auth_headers(user)

        expect(body['user']).to eq user_json(user)
      end

      it 'responds with :ok when signed in' do
        user = User.create email: 'registered@example.com', password: 'password'

        get '/api/current_user', {}, auth_headers(user)

        expect(response).to have_http_status :ok
      end

      it 'responds with :unauthorized if user is not logged in' do
        get '/api/current_user'

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
