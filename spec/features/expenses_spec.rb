require 'feature_helper'

RSpec.feature 'Users', js: true do
  given!(:employee) do
    User.create email: 'employee@example.com', password: 'password'
  end

  given!(:admin) do
    User.create email: 'admin@example.com', password: 'password', admin: true
  end

  scenario 'an employee creates an expense' do
    login employee

    click_link 'Expenses'

    expect(page).to have_text 'Expenses'

    click_link 'Create Expense'

    expect(page).to have_text 'Expenses'

    fill_in 'Date', with: 'Date'
    fill_in 'Time', with: 'Time'
    fill_in 'Description', with: 'RadAway'
    fill_in 'Amount', with: 42.00
    fill_in 'Comment', with: 'Expensive, but worth it...'

    click_button 'Submit'

    expect(page).to have_text 'Expenses'

    expect(page).to have_text 'RadAway'
    expect(page).to have_text 'Expensive, but worth it...'

    logout
  end
end
