require 'requests_helper'

RSpec.describe 'Expenses', type: :request do
  context 'unauthorized expense'do
    describe 'GET /expenses' do
      it 'responds with :unauthorized when expense is not signed in' do
        get '/api/expenses'

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'GET /expenses/1' do
      it 'responds with :unauthorized when expense is not signed in' do
        get '/api/expenses/1'

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'POST /expenses' do
      it 'responds with :unauthorized when expense is not signed in' do
        post '/api/expenses'

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'PATCH/PUT /expenses/1' do
      it 'responds with :unauthorized when expense is not signed in' do
        put '/api/expenses/1'

        expect(response).to have_http_status :unauthorized
      end
    end

    describe 'DELETE /expenses/1' do
      it 'responds with :unauthorized when expense is not signed in' do
        delete '/api/expenses/1'

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  def json(expense)
    {
      'id'          => expense.id,
      'datetime'    => expense.datetime.as_json,
      'description' => expense.description,
      'amount'      => expense.amount.as_json,
      'comment'     => expense.comment,
      'user'        => user_json(expense.user)
    }
  end

  def request_params(inner)
    { expense: inner }.to_json
  end

  def expense_params
    { user: employee, amount: 9.99 }
  end

  def create_expense(overrides)
    Expense.create expense_params.merge(overrides)
  end

  context 'authorized users' do
    let!(:admin) do
      User.create email: 'admin@example.com', password: 'password', admin: true
    end

    let!(:employee) do
      User.create email: 'employee@example.com', password: 'password'
    end

    describe 'GET /expenses' do
      it 'returns a list of expenses' do
        rads =  create_expense description: 'RadAway'
        water = create_expense description: 'Pure Water'
        stims = create_expense description: 'Stimpak'

        get '/api/expenses', {}, auth_headers(employee)

        expect(response).to have_http_status :ok

        expect(body['expenses'].count).to be 3
        expect(body['expenses']).to eq [json(rads),
                                        json(water),
                                        json(stims)]
      end

      it 'does not return expenses created by other users' do
        rads =  create_expense description: 'RadAway'
        stims = create_expense description: 'Stimpak'

        create_expense description: 'Pure Water', user: admin

        get '/api/expenses', {}, auth_headers(employee)

        expect(response).to have_http_status :ok

        expect(body['expenses'].count).to be 2
        expect(body['expenses']).to match_array [json(rads),
                                                 json(stims)]
      end
    end

    describe 'GET /expenses/1' do
      it 'returns the specific expense' do
        expense = create_expense description: 'RadAway'

        get "/api/expenses/#{expense.id}", {}, auth_headers(employee)

        expect(response).to have_http_status :ok

        expect(body['expense']).to eq json(expense)
      end

      it 'returns raises and error if the record isnot found' do
        get '/api/expenses/42', {}, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end

      it "does not return another user's expense" do
        expense = create_expense description: 'RadAway', user: admin

        get "/api/expenses/#{expense.id}", {}, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end
    end

    describe 'POST /expenses' do
      it 'creates a new expense' do
        description = 'RadAway'
        params = request_params description: description,
                                amount: 42.0,
                                user_id: employee.id

        post '/api/expenses', params, auth_headers(employee)

        new_expense = Expense.find_by description: description

        expect(new_expense.description).to eq description
      end

      it 'returns the created expense' do
        description = 'RadAway'
        params = request_params description: description,
                                amount: 42.0,
                                user_id: employee.id

        post '/api/expenses', params, auth_headers(employee)

        new_expense = Expense.find_by description: description

        expect(body['expense']).to eq json(new_expense)
      end

      it 'responds with :created on successful create' do
        params = request_params description: 'RadAway',
                                amount: 42.0,
                                user_id: employee.id

        post '/api/expenses', params, auth_headers(employee)

        expect(response).to have_http_status :created
      end

      it 'responds with :unprocessable_entity when create fails' do
        params = request_params description: nil

        post '/api/expenses', params, auth_headers(employee)

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when create fails' do
        params = request_params description: nil,
                                amount: 0.00,
                                user_id: employee.id

        post '/api/expenses', params, auth_headers(employee)

        expect(body['description']).to eq ["can't be blank"]
      end
    end

    describe 'PATCH/PUT /expenses/1 ' do
      it 'updates the specified expense' do
        description = 'RadAway'
        expense = create_expense description: 'RadAway'

        params = request_params description: 'RadAway'

        put "/api/expenses/#{expense.id}", params, auth_headers(employee)

        expense.reload

        expect(expense.description).to eq description
      end

      it 'responds with :no_content on successful update' do
        expense = create_expense description: 'RadAway'

        params = request_params description: 'RadAway'

        put "/api/expenses/#{expense.id}", params, auth_headers(employee)

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'responds with :uprocessable_entity when update fails' do
        expense = create_expense description: 'RadAway'

        params = request_params user_id: nil

        put "/api/expenses/#{expense.id}", params, auth_headers(employee)

        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders errors when update fails' do
        expense = create_expense description: 'RadAway'

        params = request_params description: nil

        put "/api/expenses/#{expense.id}", params, auth_headers(employee)

        expect(body['description']).to eq ["can't be blank"]
      end

      it 'responds with :not_found if the record is not found' do
        put '/api/expenses/42', {}, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end

      it "does not update another user's expense" do
        expense = create_expense description: 'RadAway', user: admin

        params = request_params description: 'Pure Water'

        put "/api/expenses/#{expense.id}", params, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end
    end

    describe 'DELETE /expenses/1' do
      it 'deletes the specified expense' do
        expense = create_expense description: 'RadAway'

        delete "/api/expenses/#{expense.id}", {}, auth_headers(employee)

        expect do
          Expense.find expense.id
        end.to raise_error ActiveRecord::RecordNotFound
      end

      it 'responds with :no_content on successful delete' do
        expense = create_expense description: 'RadAway'

        delete "/api/expenses/#{expense.id}", {}, auth_headers(employee)

        expect(header['Content-Type']).not_to be_present
        expect(response).to have_http_status :no_content
      end

      it 'returns raises and error if the record isnot found' do
        delete '/api/expenses/42', {}, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end

      it "does not delete another user's expense" do
        expense = create_expense description: 'RadAway', user: admin

        delete "/api/expenses/#{expense.id}", {}, auth_headers(employee)

        expect(response).to have_http_status :not_found
      end
    end

    context 'with admin privileges' do
      describe 'GET /expenses' do
        it 'returns all expenses' do
          rads =  create_expense description: 'RadAway'
          water = create_expense description: 'Pure Water', user: admin
          stims = create_expense description: 'Stimpak'

          get '/api/expenses', {}, auth_headers(admin)

          expect(response).to have_http_status :ok

          expect(body['expenses'].count).to be 3
          expect(body['expenses']).to match_array [json(rads),
                                                   json(water),
                                                   json(stims)]
        end
      end

      describe 'GET /expenses/1' do
        it 'returns any expense' do
          expense = create_expense description: 'RadAway'

          get "/api/expenses/#{expense.id}", {}, auth_headers(admin)

          expect(response).to have_http_status :ok

          expect(body['expense']).to eq json(expense)
        end
      end

      describe 'PUT /expenses/1' do
        it "updates another any user's expense" do
          expense = create_expense description: 'RadAway', user: employee

          params = request_params description: 'Pure Water'

          put "/api/expenses/#{expense.id}", params, auth_headers(admin)

          expense.reload

          expect(response).to have_http_status :no_content

          expect(expense.description).to eq 'Pure Water'
        end
      end

      describe 'DELETE /expenses/1' do
        it "delets any user's expense" do
          expense = create_expense description: 'RadAway', user: employee

          delete "/api/expenses/#{expense.id}", {}, auth_headers(admin)

          expect(response).to have_http_status :no_content

          expect do
            Expense.find expense.id
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
