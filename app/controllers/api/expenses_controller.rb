module Api
  class ExpensesController < Api::BaseController
    before_action :authenticate_user!
    before_action :set_expense, only: [:show, :update, :destroy]

    def index
      @expenses = user_expenses

      render json: @expenses
    end

    def show
      render json: @expense
    end

    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        render json: @expense, status: :created
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

    def base_params
      params
        .require(:expense)
        .permit(:datetime, :description, :amount, :comment, :user_id)
    end

    def user_id
      if current_user.admin?
        base_params[:user_id] || current_user.id
      else
        current_user.id
      end
    end

    def expense_params
      base_params.merge(user_id: user_id)
    end
  end
end
