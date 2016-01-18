class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :datetime, :description, :amount, :comment
  has_one :user
end
