require 'rails_helper'

RSpec.describe '/api/v1/auth', type: :request do
  context 'registration' do
    it 'allows api/v1/auth to sign up via the api' do
      params = {
        email: 'new_registration@example.com',
        password: 'password',
        password_confirmation: 'password'
      }

      post '/api/v1/auth', params

      expect(response).to be_success

      new_user = User.find_by email: params[:email]

      data = body['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq new_user.email
      expect(data['id']).to eq new_user.id
      expect(data['email']).to eq new_user.email
    end

    it 'does not allow duplicate registrations' do
      params = {
        email: 'new_registration@example.com',
        password: 'password',
        password_confirmation: 'password'
      }

      User.create params

      post '/api/v1/auth', params

      expect(response).to have_http_status :forbidden
      expect(User.count).to be 1
    end
  end

  context 'authentication' do
    it 'allows api/v1/auth to sign in via the api' do
      email = 'new_user@example.com'
      password = 'password'

      user = User.create email: email, password: password

      post '/api/v1/auth/sign_in', email: email, password: password

      expect(response).to have_http_status :ok

      data = body['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq email
      expect(data['id']).to eq user.id
      expect(data['email']).to eq user.email
    end

    it 'provides a authentication token to the client on successful sign in' do
      email = 'new_user@example.com'
      password = 'password'
      user = User.create email: email, password: password

      post '/api/v1/auth/sign_in', email: email, password: password

      user.reload
      client_token = user.tokens.keys.last
      expiry = user.tokens.values.last['expiry'].to_s

      expect(header['token-type']).to eq 'Bearer'
      expect(header['uid']).to eq user.uid
      expect(header['expiry']).to eq expiry
      expect(header['client']).to eq client_token
    end

    it 'does not authenticate user with an incorrect password' do
      email = 'new_user@example.com'
      password = 'password'

      User.create email: email, password: password

      post '/api/v1/auth/sign_in', email: email, password: 'INCORRECT_PASSWORD'

      expect(response).to have_http_status :unauthorized
    end

    it 'does not authenticate a user who has not registered' do
      email = 'unregistered@example.com'
      password = 'irrelevant'

      post '/api/v1/auth/sign_in', email: email, password: password

      expect(response).to have_http_status :unauthorized
    end

    it 'allows a user to sign out' do
      email = 'new_user@example.com'
      password = 'password'

      user = User.create email: email, password: password

      auth_headers = user.create_new_auth_token
      client_token = auth_headers['client']

      delete '/api/v1/auth/sign_out', {}, auth_headers

      user.reload

      expect(response).to have_http_status :ok
      expect(user.tokens[client_token]).not_to be_present
    end
  end
end
