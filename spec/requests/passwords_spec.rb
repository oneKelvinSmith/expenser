require 'requests_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'POST /users/password' do
    context 'when User exists' do
      it 'initializes reset password token and sends email' do
        user = User.create email: 'user@example.com', password: 'password'

        expect(user.reset_password_token.present?).to eq false
        expect(ActionMailer::Base.deliveries.count).to eq 0

        post '/users/password', format: :json, user: { email: user.email }

        user.reload
        expect(user.reset_password_token.present?).to eq true

        expect(ActionMailer::Base.deliveries.count).to eq 1
        delivery = ActionMailer::Base.deliveries.first
        expect(delivery.to).to eq [user.email]
        expect(delivery.body).to include('reset_password_token')

        expect(body).to eq({})
        expect(response.status).to eq 201
      end
    end

    context 'when is not in the' do
      it 'returns errors' do
        post '/users/password',
             format: :json,
             user: { email: 'not_a_user@example.com' }

        expect(body['errors']).to eq('email' => ['not found'])
        expect(response.status).to eq 422

        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end

  describe 'PUT /users/password' do
    context 'when User exists' do
      context 'with valid params' do
        context 'when passing valid token' do
          it 'updates password' do
            user = User.create email: 'user@example.com', password: 'password'
            reset_token = user.send_reset_password_instructions

            put '/users/password',
                format: :json,
                user: {
                  reset_password_token: reset_token,
                  password: 'new_password',
                  password_confirmation: 'new_password'
                }

            user.reload

            expect(user.reset_password_token).to be_nil
            expect(user.valid_password?('new_password')).to be true

            expect(response.body.blank?).to be true
            expect(response).to have_http_status :no_content
          end
        end
      end

      context 'with invalid params' do
        context 'when passing invalid token' do
          it 'does not update password' do
            user = User.create email: 'user@example.com', password: 'password'
            user.send_reset_password_instructions

            put '/users/password',
                format: :json,
                user: {
                  reset_password_token: 'INVALID',
                  password: 'new_password',
                  password_confirmation: 'new_password'
                }

            user.reload

            expect(user.reset_password_token).to be_present
            expect(user.valid_password?('new_password')).to be false

            expect(body['errors'])
              .to eq('reset_password_token' => ['is invalid'])

            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context 'when passing invalid password' do
          it 'does not update password' do
            user = User.create email: 'user@example.com', password: 'password'
            reset_token = user.send_reset_password_instructions

            put '/users/password',
                format: :json,
                user: {
                  reset_password_token: reset_token,
                  password: 'SHORT',
                  password_confirmation: 'MISMATCH'
                }

            user.reload

            expect(user.reset_password_token.present?).to eq true

            expect(body['errors'])
              .to eq('password_confirmation' => ["doesn't match Password"],
                     'password' => ['is too short (minimum is 8 characters)'])

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
