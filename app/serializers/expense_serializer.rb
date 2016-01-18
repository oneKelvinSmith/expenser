class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :datetime, :description, :amount, :comment
  has_one :user

  embed :ids, embed_in_root: true
end
