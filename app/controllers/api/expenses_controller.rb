module Api
  class ExpensesController < Api::BaseController
    before_action :authenticate_user!
    before_action :set_expense, only: [:show, :update, :destroy]

    def index
      @expenses = user_expenses

      render json: @expenses, adapter: :json
    end

    def show
      render json: @expense, adapter: :json
    end

    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        render json: @expense, status: :created, adapter: :json
      else
        render json: @expense.errors, status: :unprocessable_entity
      end
    end

    def update
      if @expense.update(expense_params)
        head :no_content
      else
        render json: @expense.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @expense.destroy

      head :no_content
    end

    private

    def user_expenses
      Expense.for_user(current_user)
    end

    def set_expense
      @expense = user_expenses.find(params[:id])
    end

    def expense_params
      params
        .require(:expense)
        .permit(:date, :time, :description, :amount, :comment, :user_id)
    end
  end
end
