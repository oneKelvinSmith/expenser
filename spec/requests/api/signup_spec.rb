require 'requests_helper'

RSpec.describe 'Signup', type: :request do
  describe 'POST /api/signup' do
    it 'responds with :created' do
      credentials = {
        email: 'new_user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }

      post '/api/signup', credentials

      expect(response).to have_http_status :created
    end

    it 'creates a new user' do
      credentials = {
        email: 'new_user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }

      post '/api/signup', credentials

      expect(User.last.email).to eq credentials[:email]
    end

    it 'responds with :unprocessable_entity when the user exists' do
      credentials = {
        email: 'new_user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }

      User.create credentials

      post '/api/signup', credentials

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'responds with error messages on a failed registration' do
      credentials = {
        email: 'new_user@example.com',
        password: 'SHORT',
        password_confirmation: 'MISMATCH'
      }

      post '/api/signup', credentials

      expect(response).to have_http_status :unprocessable_entity
      expect(body['errors'])
        .to eq ["Password confirmation doesn't match Password",
                'Password is too short (minimum is 8 characters)']
    end

    it 'does not create a user when password confirmation is nil' do
      credentials = {
        email: 'new_user@example.com',
        password: 'password',
        password_confirmation: nil
      }

      post '/api/signup', credentials

      expect(response).to have_http_status :unprocessable_entity
      expect(body['errors'])
        .to eq ["Password confirmation doesn't match Password"]
    end
  end
end
