require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'registration' do
    it 'works' do
      email = 'test@example.com'
      post '/users', email: email,
                     password: 'password',
                     password_confirmation: 'password'

      expect(response).to be_success

      new_user = User.find_by email: email
      data = json['data']

      expect(data['id']).to eq new_user.id
      expect(data['email']).to eq new_user.email
    end
  end
end
