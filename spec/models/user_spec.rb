require 'rails_helper'

RSpec.describe User do
  context 'roles' do
    describe '#role' do
      it 'defaults to the :user role' do
        expect(User.new.role).to eq 'user'
      end

      it 'returns the :admin role when set' do
        expect(User.new(role: 1).role).to eq 'admin'
      end

      it 'raises error when trying to set an invalid role' do
        expect do
          User.new(role: 42)
        end.to raise_error ArgumentError, "'42' is not a valid role"
      end
    end

    describe '#user?' do
      it 'is true when :user role is set' do
        expect(User.new(role: 0)).to be_user
        expect(User.new(role: 1)).not_to be_user
      end
    end

    describe '#user!' do
      it 'sets the :user role' do
        params = { email: 'user@example.com', password: 'password', role: 1 }
        user = User.create(params)

        user.user!

        expect(user).to be_user
      end
    end

    describe '#admin?' do
      it 'is true when :user role is set' do
        expect(User.new(role: 1)).to be_admin
        expect(User.new(role: 0)).not_to be_admin
      end
    end

    describe '#admin!' do
      it 'sets the :admin role' do
        params = { email: 'admin@example.com', password: 'password' }
        user = User.create(params)

        user.admin!

        expect(user).to be_admin
      end
    end
  end
end
