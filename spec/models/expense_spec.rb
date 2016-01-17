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
        expect(expense.errors[:amount])
          .to include 'must be greater than or equal to 0.01'
      end

      context 'date and time' do
        it 'sets default date and time on validation' do
          now = DateTime.now

          expense = Expense.new
          expense.clock = OpenStruct.new(now: now)

          expect(expense.datetime).to be_nil

          expense.valid?

          expect(expense.datetime).to eq now
        end

        it 'does not default date and time when they have been set' do
          now = DateTime.now

          expense = Expense.new datetime: DateTime.now - 1.hour

          expense.valid?

          expect(expense.datetime).not_to eq now
        end
      end
    end
  end
end
