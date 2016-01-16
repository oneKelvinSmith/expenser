require 'feature_helper'

RSpec.feature 'Users', js: true do
  given(:employee) do
    User.create email: 'employee@example.com', password: 'password'
  end

  given(:admin) do
    User.create email: 'admin@example.com', password: 'password', admin: true
  end

  scenario 'employees cannot administer users' do
    visit '/'

    expect(page).not_to have_link 'Users'

    login employee

    expect(page).to have_text employee.email

    expect(page).not_to have_link 'Users'

    visit '/users'

    expect(page).to have_text 'Log in'

    expect(page.current_path).to eq '/login'
  end
end
