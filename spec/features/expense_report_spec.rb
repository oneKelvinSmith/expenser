require 'feature_helper'

RSpec.feature 'Expense Report', js: true do
  given!(:employee) do
    User.create email: 'employee@example.com', password: 'password'
  end

  given!(:time) { DateTime.now.middle_of_day }
  given!(:week_ending) do
    formatted_date time.end_of_week
  end

  given!(:water) do
    Expense.create description: 'Pure Water', datetime: time,
                   amount: 3.50,
                   comment: 'Just the best water...',
                   user: employee
  end

  given!(:cells) do
    Expense.create description: 'Energy Cells', datetime: time - 1.hour,
                   amount: 3.50,
                   comment: 'For L4z0rz...',
                   user: employee
  end

  given!(:nukacola) do
    Expense.create description: 'NukaCola', datetime: time - 1.week,
                   amount: 42.00,
                   comment: 'To quench the thirst...',
                   user: employee
  end

  scenario 'an employee reviews an expense report' do
    login employee

    click_link 'Expenses'

    expect(page).to have_text water.description
    expect(page).to have_text cells.description
    expect(page).to have_text nukacola.description

    click_link 'Report'

    expect(page).to have_text "Week ending: #{week_ending}"

    expect(page).to have_text 'Total Amount'
    expect(page).to have_text '$ 7.00'

    expect(page).to have_text 'Average Daily Spend'
    expect(page).to have_text '$ 1.00'

    expect(page).to have_button 'Print'

    logout
  end
end
