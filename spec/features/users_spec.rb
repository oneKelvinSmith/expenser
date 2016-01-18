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
    login admin

    expect(page).to have_text admin.email
    expect(page).not_to have_text employee.email

    click_link 'Users'

    expect(page).to have_text 'Users'
    expect(page).to have_text employee.email

    expect(page.current_path).to eq '/users'

    within "#user-#{employee.id}" do
      click_link 'Show'
    end

    expect(page).to have_text 'Show User'
    expect(page.current_path).to eq "/users/#{employee.id}"

    click_link 'Back to Users'

    within "#user-#{employee.id}" do
      click_link 'Edit'
    end

    expect(page).to have_text 'Edit User'
    expect(page.current_path).to eq "/users/#{employee.id}/edit"

    fill_in 'Email', with: 'updated@example.com'

    click_button 'Save'

    expect(page).to have_text 'updated@example.com'
    expect(page).not_to have_text employee.email

    expect(page.current_path).to eq '/users'

    within "#user-#{employee.id}" do
      click_link 'Remove'
    end

    expect(page).not_to have_text 'updated@example.com'

    logout
  end

  scenario 'admin creates another admin' do
    login admin

    expect(page).to have_text admin.email
    expect(page).not_to have_text employee.email

    click_link 'Users'

    click_link 'New User'

    expect(page).to have_text 'New User'
    expect(page.current_path).to eq "/users/new"

    fill_in 'Email', with: 'new_admin@example.com'
    check 'Admin'

    click_button 'Save'

    expect(page).to have_text 'new_admin@example.com'

    logout
  end
end
