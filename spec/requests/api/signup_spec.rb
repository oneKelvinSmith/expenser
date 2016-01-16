require 'requests_helper'

RSpec.describe 'Signup', type: :request do
  describe 'POST /api/signup' do
    it 'responds with :created' do
      credentials = { email: 'new@example.com', password: 'password' }

      post '/api/signup', credentials

      expect(response).to have_http_status :created
    end

    it 'creates a new user' do
      credentials = { email: 'new@example.com', password: 'password' }

      post '/api/signup', credentials

      expect(User.last.email).to eq credentials[:email]
    end

    it 'responds with :unprocessable_entity when the user exists' do
      credentials = { email: 'new@example.com', password: 'password' }
      User.create credentials

      post '/api/signup', credentials

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'responds with error messages on a failed registration' do
      credentials = { email: 'new@example.com', password: 'password' }
      error_message = 'must contain an act of malice'

      user = User.new credentials
      user.errors.add('password', error_message)

      allow(User).to receive(:new).and_return(user)
      allow(user).to receive(:save).and_return(false)

      post '/api/signup', credentials

      expect(response).to have_http_status :unprocessable_entity
      expect(body['errors']).to eq ["Password #{error_message}"]
    end
  end
end
