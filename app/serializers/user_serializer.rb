class UserSerializer < ActiveModel::Serializer
  attributes :id, :provider, :name, :email, :role
end
