require 'rails_helper'

RSpec.describe '/api/v1/users', type: :request do
  context 'registration' do
    it 'allows api/v1/users to sign up via the api' do
      email = 'test@example.com'
      password = 'super_secure'

      post '/api/v1/users', email: email,
                            password: password,
                            password_confirmation: password

      expect(response).to be_success

      new_user = User.find_by email: email

      data = body['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq email
      expect(data['id']).to eq new_user.id
      expect(data['email']).to eq new_user.email
    end

    it 'does not allow duplicate registrations' do
      email = 'test@example.com'
      password = 'super_secure'

      User.create email: email, password: password

      post '/api/v1/users', email: email,
                            password: password,
                            password_confirmation: password

      expect(response).to have_http_status :forbidden
      expect(User.count).to be 1
    end
  end

  context 'authentication' do
    it 'allows api/v1/users to sign in via the api' do
      email = 'test@example.com'
      password = 'super_secure'

      user = User.create email: email, password: password

      post '/api/v1/users/sign_in', email: email, password: password

      expect(response).to have_http_status :ok

      data = body['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq email
      expect(data['id']).to eq user.id
      expect(data['email']).to eq user.email
    end

    it 'provides a authentication token to the client on successful sign in' do
      email = 'test@example.com'
      password = 'super_secure'

      user = User.create email: email, password: password

      post '/api/v1/users/sign_in', email: email, password: password

      user.reload
      client_token = user.tokens.keys.last
      expiry = user.tokens.values.last['expiry'].to_s

      expect(header['token-type']).to eq 'Bearer'
      expect(header['uid']).to eq user.uid
      expect(header['expiry']).to eq expiry
      expect(header['client']).to eq client_token
    end

    it 'does not authenticate user with an incorrect password' do
      email = 'test@example.com'
      password = 'super_secure'

      User.create email: email, password: password

      post '/api/v1/users/sign_in', email: email, password: 'INCORRECT_PASSWORD'

      expect(response).to have_http_status :unauthorized
    end

    it 'does not authenticate a user who has not registered' do
      post '/api/v1/users/sign_in', email: 'test@example.com',
                                    password: 'irrelevant'

      expect(response).to have_http_status :unauthorized
    end

    it 'allows a user to sign out' do
      user = User.create email: 'test@example.com', password: 'password'
      auth_headers = user.create_new_auth_token
      client_token = auth_headers['client']

      delete '/api/v1/users/sign_out', {}, auth_headers

      user.reload

      expect(response).to have_http_status :ok
      expect(user.tokens[client_token]).not_to be_present
    end
  end
end
