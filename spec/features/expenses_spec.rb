require 'feature_helper'

RSpec.feature 'Users', js: true do
  given!(:time) { DateTime.now }

  given!(:employee) do
    User.create email: 'employee@example.com', password: 'password'
  end

  given!(:admin) do
    User.create email: 'admin@example.com', password: 'password', admin: true
  end

  given!(:expense) do
    Expense.create description: 'Pure Water', datetime: time,
                   amount: 9.99,
                   comment: 'Just the best water...',
                   user: employee
  end

  given!(:first_expense) do
    Expense.create description: 'Energy Cells', datetime: time + 1.hour,
                   amount: 34.49,
                   comment: 'For L4z0rz...',
                   user: employee
  end

  given!(:middle_expense) do
    Expense.create description: 'Rags', datetime: time,
                   amount: 99.01,
                   comment: 'To clean with...',
                   user: employee
  end

  given!(:last_expense) do
    Expense.create description: 'NukaCola', datetime: time - 1.hour,
                   amount: 4.45,
                   comment: 'To quench the thirst...',
                   user: employee
  end

  scenario 'an employee creates an expense' do
    login employee

    click_link 'Expenses'

    expect(page).to have_text 'Expenses'

    click_link 'New Expense'

    expect(page).to have_text 'New Expense'
    expect(page.current_path).to eq '/expenses/new'

    # datetime_input = find('#when').find('input')
    # datetime_input.click
    # datetime_input.set(now.iso8601)

    fill_in 'Description', with: 'RadAway'
    fill_in 'Amount', with: 42.42
    fill_in 'Comment', with: 'Expensive, but worth it...'

    click_button 'Save'

    expect(page).to have_text 'Expenses'
    expect(page).not_to have_link 'Back to Expenses'

    expect(page.current_path).to eq '/expenses'

    expect(page).to have_text formatted_date(now)
    expect(page).to have_text formatted_time(now)
    expect(page).to have_text 'RadAway'
    expect(page).to have_text '$ 42.42'
    expect(page).to have_text 'Expensive, but worth it...'

    logout
  end

  scenario 'an employee administers an expense' do
    login employee

    click_link 'Expenses'

    within "#expense-#{expense.id}" do
      click_link 'Edit'
    end

    fill_in 'Description', with: 'Dirty Water'
    fill_in 'Amount', with: 0.01
    fill_in 'Comment', with: 'Ugh!'

    click_button 'Save'

    within "#expense-#{expense.id}" do
      click_link 'Show'
    end

    expect(page).to have_text formatted_date(time)
    expect(page).to have_text formatted_time(time)
    expect(page).to have_text 'Dirty Water'
    expect(page).to have_text '$ 0.01'
    expect(page).to have_text 'Ugh!'

    click_link 'Back to Expenses'

    within "#expense-#{expense.id}" do
      click_link 'Remove'
    end

    expect(page).not_to have_text 'Dirty Water'

    logout
  end

  scenario 'an employee filters expenses' do
    login employee

    click_link 'Expenses'

    expect(page).to have_text 'Rags'
    expect(page).to have_text 'Pure Water'
    expect(page).to have_text 'Energy Cells'

    fill_in 'Filter Description', with: 'water'

    expect(page).to have_text 'Pure Water'

    expect(page).not_to have_text 'Energy Cells'
    expect(page).not_to have_text 'Rags'

    logout
  end
end
