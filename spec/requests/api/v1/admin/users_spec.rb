require 'rails_helper'

RSpec.describe '/api/v1/admin/users' do
  describe 'GET /users' do
    it 'returns a list of user' do
      password = 'password'
      dudette = User.create email: 'dudette@example.com', password: password
      dude = User.create email: 'dude@example.com', password: password

      get '/api/v1/admin/users'

      expect(response).to have_http_status :ok

      expect(body.count).to be 2
      expect(body.first['email']).to eq dudette.email
      expect(body.last['email']).to eq dude.email
    end
  end
end
