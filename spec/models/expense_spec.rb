require 'rails_helper'

RSpec.describe Expense do
  context 'validations' do
    describe '#valid?' do
      it 'is not valid by default' do
        expense = Expense.new

        expect(expense).not_to be_valid

        expect(expense.errors[:description]).to include "can't be blank"
        expect(expense.errors[:amount]).to include "can't be blank"
        expect(expense.errors[:user]).to include "can't be blank"
      end

      it 'is valid when when description, amount and user are set' do
        user = User.new(id: 42)
        expense = Expense.new description: 'Lunch', amount: 42.0, user: user

        expect(expense).to be_valid
      end

      it 'is not valid when amount in less than 0.01' do
        user = User.new(id: 42)
        expense = Expense.new description: 'Lunch', amount: 0.001, user: user

        expect(expense).not_to be_valid
        expect(expense.errors[:amount]).to include 'must be greater than or equal to 0.01'
      end

      context 'date and time' do
        it 'sets default date and time on validation' do
          now = Time.now
          today = Date.today

          expense = Expense.new
          expense.clock = OpenStruct.new(now: now)

          expect(expense.time).to be_nil
          expect(expense.date).to be_nil

          expense.valid?

          expect(expense.time).to eq now
          expect(expense.date).to eq today
        end

        it 'does not default date and time when they have been set' do
          now = Time.now
          today = Date.today

          expense = Expense.new time: Time.now - 1.hour, date: Date.yesterday

          expense.valid?

          expect(expense.time).not_to eq now
          expect(expense.date).not_to eq today
        end
      end
    end
  end
end
