require 'feature_helper'

RSpec.feature 'Registrations', js: true do
  scenario 'signing up with correct credentials' do
    visit '/'

    expect(page).to have_text 'Welcome to Timekeeper'

    expect(page).to have_link 'Sign up'
    expect(page).to have_link 'Log in'

    expect(page).not_to have_link 'Log out'

    click_link 'Sign up'

    fill_in 'Email',            with: 'newuser@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'password'

    click_button 'Register'

    expect(page).to have_text 'Welcome to Timekeeper'

    # expect(page).to have_content 'newuser@example.com'
    # expect(page).to have_content 'Timekeeping'

    expect(page).to have_button 'Log out'

    expect(page).not_to have_link 'Sign up'
    expect(page).not_to have_link 'Log in'
  end
end
