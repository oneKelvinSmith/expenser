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

  describe 'GET /users/1' do
    it 'returns the specific user' do
      dudette = User.create email: 'dudette@example.com', password: 'password'

      get "/api/v1/admin/users/#{dudette.id}"

      expect(response).to have_http_status :ok

      expect(body).to eq json_for(dudette)
    end

    it 'returns raises and error if the record isnot found' do
      expect do
        get '/api/v1/admin/users/42'
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'PUT /users/1 ' do
    it 'updates the specified user' do
      dudette = User.create email: 'dudette@example.com', password: 'password'

      user_params = {
        name: 'Dude',
        email: 'dude@example.com'
      }

      put "/api/v1/admin/users/#{dudette.id}", user: user_params

      dudette.reload

      expect(dudette.name).to eq user_params[:name]
      expect(dudette.email).to eq user_params[:email]
      expect(dudette.uid).to eq user_params[:email]
    end

    it 'responds with :no_content on successful update' do
      dudette = User.create email: 'dudette@example.com', password: 'password'

      put "/api/v1/admin/users/#{dudette.id}", user: { name: 'Wendy' }

      expect(header['Content-Type']).not_to be_present
      expect(response).to have_http_status :no_content
    end

    it 'responds with :uprocessable_entity when update fails' do
      dudette = User.create email: 'dudette@example.com', password: 'password'

      allow(User).to receive(:find).and_return dudette
      allow(dudette).to receive(:update).and_return false

      put "/api/v1/admin/users/#{dudette.id}", user: { name: 'BADNESS' }

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'renders errors when update fails' do
      dudette = User.create email: 'dudette@example.com', password: 'password'
      dudette.errors.add(:name, 'Badness has occurred')

      allow(User).to receive(:find).and_return dudette
      allow(dudette).to receive(:update).and_return false

      put "/api/v1/admin/users/#{dudette.id}", user: { name: 'BADNESS' }

      expect(body['name']).to eq ['Badness has occurred']
    end
  end

  def json_for(user)
    {
      'provider' => 'email',
      'id'       => user.id, 'uid'      => user.email,
      'name'     => nil,     'nickname' => nil,
      'image'    => nil,     'email'    => user.email,
      'created_at' => user.created_at.as_json,
      'updated_at' => user.updated_at.as_json
    }
  end
end
