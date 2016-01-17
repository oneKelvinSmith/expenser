require 'feature_helper'

RSpec.feature 'Users', js: true do
  given!(:employee) do
    User.create email: 'employee@example.com', password: 'password'
  end

  given!(:admin) do
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

  scenario 'admin administers an employee' do
    visit '/'

    login admin

    expect(page).to have_text admin.email
    expect(page).not_to have_text employee.email

    click_link 'Users'

    expect(page).to have_text 'Users'
    expect(page).to have_text employee.email

    expect(page.current_path).to eq '/users'

    find("a[href=\"/users/#{employee.id}\"]").click

    expect(page).to have_text 'User show'

    click_link 'User list'

    find("a[href=\"/users/#{employee.id}/edit\"]").click

    expect(page).to have_text 'Edit User'

    fill_in 'Email', with: 'updated@example.com'

    click_button 'Save'

    expect(page).to have_text 'updated@example.com'
    expect(page).not_to have_text employee.email

    expect(page.current_path).to eq '/users'

    # click_button 'Remove'

    # expect(page).not_to have_text 'updated@example.com'

    logout
  end
end
