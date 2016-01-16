require 'requests_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /oauth/token' do
    describe 'grant_type password' do
      context 'with valid params' do
        context 'without client credentials' do
          it 'returns token' do
            user = User.create email: 'user@example.com', password: 'password'

            post '/oauth/token',
                 'grant_type' => 'password',
                 'username' => user.email,
                 'password' => 'password'

            expect(Doorkeeper::AccessToken.count).to eq 1
            expect(Doorkeeper::AccessToken.first.application_id).to eq nil

            expect(body['access_token'].size).to eq 64
            expect(body['refresh_token'].size).to eq 64
            expect(body['token_type']).to eq 'bearer'
            expect(body['expires_in']).to eq 7200
            expect(body['created_at'].present?).to eq true

            expect(response).to have_http_status :success
          end
        end

        context 'with client credentials' do
          it 'returns token' do
            user = User.create email: 'user@example.com', password: 'password'

            client = Doorkeeper::Application
                     .create name: 'Client', redirect_uri: 'https://example.com'

            post '/oauth/token',
                 'grant_type' => 'password',
                 'username' => user.email,
                 'password' => 'password',
                 'client_id' => client.uid,
                 'client_secret' => client.secret

            expect(Doorkeeper::AccessToken.count).to eq 1
            expect(Doorkeeper::AccessToken.first.application_id).to eq client.id

            expect(body['access_token'].size).to eq 64
            expect(body['refresh_token'].size).to eq 64
            expect(body['token_type']).to eq 'bearer'
            expect(body['expires_in']).to eq 7200
            expect(body['created_at'].present?).to eq true

            expect(response).to have_http_status :success
          end
        end
      end

      context 'when credentials are not valid', :skip_reqres do
        it 'returns error' do
          post '/oauth/token',
               'grant_type' => 'password',
               'username' => 'invalid@example.com',
               'password' => 'invalid'

          description = 'The provided authorization grant is invalid, expired,'\
                        ' revoked, does not match the redirection URI used in'\
                        ' the authorization request,'\
                        ' or was issued to another client.'

          expect(body).to eq 'error' => 'invalid_grant',
                             'error_description' => description

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    describe 'grant_type client_credentials' do
      context 'with valid params' do
        it 'returns token' do
          client = Doorkeeper::Application
                   .create name: 'Client', redirect_uri: 'https://example.com'

          post '/oauth/token',
               'grant_type' => 'client_credentials',
               'client_id' => client.uid,
               'client_secret' => client.secret

          expect(Doorkeeper::AccessToken.count).to eq 1
          expect(Doorkeeper::AccessToken.first.application_id).to eq client.id

          expect(body['access_token'].size).to eq 64
          expect(body['refresh_token']).to eq nil
          expect(body['token_type']).to eq 'bearer'
          expect(body['expires_in']).to eq 7200
          expect(body['created_at'].present?).to eq true
          expect(response).to have_http_status 200
        end
      end
    end

    describe 'grant_type refresh_token' do
      it 'returns new token' do
        user = User.create! email: 'user@example.com', password: 'password'

        client = Doorkeeper::Application
                 .create!(name: 'Client', redirect_uri: 'https://example.com')

        token = client
                .access_tokens
                .create!(use_refresh_token: true, resource_owner_id: user.id)
                .refresh_token

        post '/oauth/token',
             'grant_type'    => 'refresh_token',
             'refresh_token' => token,
             'client_id'     => client.uid,
             'client_secret' => client.secret

        expect(Doorkeeper::AccessToken.count).to eq 2
        expect(Doorkeeper::AccessToken.second.application_id).to eq client.id

        expect(body['access_token'].size).to eq 64
        expect(body['refresh_token'].size).to eq 64
        expect(body['refresh_token'].size).to_not eq token
        expect(body['token_type']).to eq 'bearer'
        expect(body['expires_in']).to eq 7200
        expect(body['created_at'].present?).to eq true
        expect(response).to have_http_status 200
      end
    end
  end
end
