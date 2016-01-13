require 'rails_helper'

RSpec.describe '/api/v1/admin/users' do
  describe 'GET /users' do
    it 'returns a list of users' do
      password = 'password'
      dudette = User.create email: 'dudette@example.com', password: password
      dude = User.create email: 'dude@example.com', password: password

      get '/api/v1/admin/users'

      expect(response).to have_http_status :ok

      expect(body.count).to be 2
      expect(body).to eq [json_for(dudette), json_for(dude)]
    end
  end

  describe 'GET /users/:id' do
    it 'returns the specific user' do
      dudette = User.create email: 'dudette@example.com', password: 'password'

      get "/api/v1/admin/users/#{dudette.id}"

      expect(body).to eq json_for(dudette)
    end
  end

  def json_for(user)
    {
      'id' => user.id,
      'provider' => 'email',
      'uid' => user.email,
      'name' => nil,
      'nickname' => nil,
      'image' => nil,
      'email' => user.email,
      'created_at' => user.created_at.as_json,
      'updated_at' => user.updated_at.as_json
    }
  end
end
