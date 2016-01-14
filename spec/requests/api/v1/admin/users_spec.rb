require 'rails_helper'

RSpec.describe '/api/v1/admin/users' do
  def json_for(user)
    {
      'id'       => user.id,
      'provider' => 'email',
      'uid'      => user.email,
      'name'     => user.name,
      'email'    => user.email,
      'role'     => user.role,
      'created_at' => user.created_at.as_json,
      'updated_at' => user.updated_at.as_json
    }
  end

  context 'unauthorized user'do
    describe 'GET /users' do
      it 'responds with :unauthorized when user is not signed in' do
        get '/api/v1/admin/users'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = User.create email: 'user@example.com', password: 'password'
        user.user!

        auth_headers = user.create_new_auth_token

        get '/api/v1/admin/users', {}, auth_headers

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'GET /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        get '/api/v1/admin/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = User.create email: 'user@example.com', password: 'password'
        user.user!

        auth_headers = user.create_new_auth_token

        get '/api/v1/admin/users/1', {}, auth_headers

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'POST /users' do
      it 'responds with :unauthorized when user is not signed in' do
        post '/api/v1/admin/users'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = User.create email: 'user@example.com', password: 'password'
        user.user!

        auth_headers = user.create_new_auth_token

        post '/api/v1/admin/users', {}, auth_headers

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'PATCH/PUT /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        put '/api/v1/admin/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = User.create email: 'user@example.com', password: 'password'
        user.user!

        auth_headers = user.create_new_auth_token

        put '/api/v1/admin/users/1', {}, auth_headers

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'DELETE /users/1' do
      it 'responds with :unauthorized when user is not signed in' do
        delete '/api/v1/admin/users/1'

        expect(response).to have_http_status :unauthorized
      end

      it 'responds with :unauthorized when user is not an admin' do
        user = User.create email: 'user@example.com', password: 'password'
        user.user!

        auth_headers = user.create_new_auth_token

        delete '/api/v1/admin/users/1', {}, auth_headers

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  context 'authorized administrator' do
    let!(:admin) do
      User.create email: 'admin@example.com', password: 'password', role: 1
    end
    let(:auth_headers) { admin.create_new_auth_token }

    describe 'GET /users' do
      it 'returns a list of users' do
        password = 'password'
        dudette = User.create email: 'dudette@example.com', password: password
        dude = User.create email: 'dude@example.com', password: password

        get '/api/v1/admin/users', {}, auth_headers

        expect(response).to have_http_status :ok

        expect(body.count).to be 3
        expect(body).to eq [
          json_for(dudette),
          json_for(dude),
          json_for(admin)
        ]
      end
    end

    describe 'GET /users/1' do
      it 'returns the specific user' do
        dudette = User.create email: 'dudette@example.com', password: 'password'

        get "/api/v1/admin/users/#{dudette.id}", {}, auth_headers

        expect(response).to have_http_status :ok

        expect(body).to eq json_for(dudette)
      end

      it 'returns raises and error if the record isnot found' do
        expect do
          get '/api/v1/admin/users/42', {}, auth_headers
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'POST /users' do
      it 'creates a new user' do
        params = {
          email: 'new_user@example.com',
          name: 'New User',
          password: 'password',
          password_confirmation: 'password'
        }

        post '/api/v1/admin/users', { user: params }, auth_headers

        new_user = User.find_by email: params[:email]

        expect(new_user.name).to eq params[:name]
      end

      it 'returns the created user' do
        params = {
          email: 'new_user@example.com',
          name: 'New User',
          password: 'password',
          password_confirmation: 'password'
        }

        post '/api/v1/admin/users', { user: params }, auth_headers

        new_user = User.find_by email: params[:email]

        expect(body).to eq json_for(new_user)
      end

      it 'responds with :created on successful create' do
        params = {
          email: 'new_user@example.com',
          name: 'New User',
          password: 'password',
          password_confirmation: 'password'
        }

        post '/api/v1/admin/users', { user: params }, auth_headers

        expect(response).to have_http_status :created
      end

      it 'responds with :unprocessable_entity when create fails' do
        params = {
          email: 'new_user@example.com',
          name: 'New User',
          password: 'password',
          password_confirmation: 'password'
        }

        new_user = User.new params

        allow(User).to receive(:new).and_return new_user
        allow(new_user).to receive(:save).and_return false

        post '/api/v1/admin/users', { user: params }, auth_headers

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when update fails' do
        params = {
          email: 'new_user@example.com',
          name: 'New User',
          password: 'password',
          password_confirmation: 'password'
        }

        new_user = User.new params
        new_user.errors.add('email', 'Email has been taken')

        allow(User).to receive(:new).and_return new_user
        allow(new_user).to receive(:save).and_return false

        post '/api/v1/admin/users', { user: params }, auth_headers

        expect(body['email']).to eq ['Email has been taken']
      end
    end

    describe 'PATCH/PUT /users/1 ' do
      it 'updates the specified user' do
        dudette = User.create email: 'dudette@example.com', password: 'password'

        params = {
          name: 'Dude',
          email: 'dude@example.com'
        }

        put "/api/v1/admin/users/#{dudette.id}", { user: params }, auth_headers

        dudette.reload

        expect(dudette.name).to eq params[:name]
        expect(dudette.email).to eq params[:email]
        expect(dudette.uid).to eq params[:email]
      end

      it 'responds with :no_content on successful update' do
        dudette = User.create email: 'dudette@example.com', password: 'password'

        params = { name: 'New Name' }

        put "/api/v1/admin/users/#{dudette.id}", { user: params }, auth_headers

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'responds with :uprocessable_entity when update fails' do
        dudette = User.create email: 'dudette@example.com', password: 'password'

        allow(User).to receive(:find).and_return dudette
        allow(dudette).to receive(:update).and_return false

        params = { user: { name: 'BADNESS' } }

        put "/api/v1/admin/users/#{dudette.id}", params, auth_headers

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when update fails' do
        dudette = User.create email: 'dudette@example.com', password: 'password'
        dudette.errors.add(:name, 'Badness has occurred')

        allow(User).to receive(:find).and_return dudette
        allow(dudette).to receive(:update).and_return false

        params = { name: 'BADNESS' }

        put "/api/v1/admin/users/#{dudette.id}", { user: params }, auth_headers

        expect(body['name']).to eq ['Badness has occurred']
      end

      it 'returns raises and error if the record isnot found' do
        expect do
          put '/api/v1/admin/users/42', {}, auth_headers
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'DELETE /users/1' do
      it 'deletes the specified user' do
        dude = User.create email: 'dude@example.com', password: 'password'

        delete "/api/v1/admin/users/#{dude.id}", {}, auth_headers

        expect do
          User.find dude.id
        end.to raise_error ActiveRecord::RecordNotFound
      end

      it 'responds with :no_content on successful delete' do
        dude = User.create email: 'dudette@example.com', password: 'password'

        delete "/api/v1/admin/users/#{dude.id}", {}, auth_headers

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'returns raises and error if the record isnot found' do
        expect do
          delete '/api/v1/admin/users/42', {}, auth_headers
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
