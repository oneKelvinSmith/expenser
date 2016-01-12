require 'feature_helper'

RSpec.feature 'Authentication', js: true do
  scenario 'allows a registered user to log in' do
    registered_email = 'existing_user@example.com'
    password = 'password'

    User.create email: registered_email, password: password

    visit '/'

    expect(page).to have_link 'Log in'
    expect(page).not_to have_button 'Log out'

    click_link 'Log in'

    expect(page).to have_text 'Log in'

    fill_in 'Email', with: registered_email
    fill_in 'Password', with: password

    click_button 'Authenticate'

    expect(page).not_to have_link 'Log in'
    expect(page).to have_button 'Log out'
  end
end
