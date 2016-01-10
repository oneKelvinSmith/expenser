require 'rails_helper'

RSpec.describe '/users', type: :request do
  context 'registration' do
    it 'allows users to sign up via the api' do
      email = 'test@example.com'
      password = 'super_secure'

      post '/users', email: email,
                     password: password,
                     password_confirmation: password

      expect(response).to be_success

      new_user = User.find_by email: email

      data = json['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq email
      expect(data['id']).to eq new_user.id
      expect(data['email']).to eq new_user.email
    end

    it 'does not allow duplicate registrations' do
      email = 'test@example.com'
      password = 'super_secure'

      User.create email: email, password: password

      post '/users', email: email,
                     password: password,
                     password_confirmation: password

      expect(response.status).to be 403
    end
  end

  context 'authentication' do
    it 'allows users to sign in via the api' do
      email = 'test@example.com'
      password = 'super_secure'

      user = User.create email: email, password: password

      post '/users/sign_in', email: email, password: password

      expect(response).to be_success

      data = json['data']
      expect(data['provider']).to eq 'email'
      expect(data['uid']).to eq email
      expect(data['id']).to eq user.id
      expect(data['email']).to eq user.email
    end

    it 'does not authentcate user with an incorrect password' do
      email = 'test@example.com'
      password = 'super_secure'

      User.create email: email, password: password

      post '/users/sign_in', email: email, password: 'INCORRECT_PASSWORD'

      expect(response.status).to be 401
    end

    it 'does not authenticate users that have not registered' do
      post '/users/sign_in', email: 'test@example.com', password: 'irrelevant'

      expect(response.status).to be 401
    end

    it 'allows users to sign out' do

    end
  end
end
