require 'feature_helper'

RSpec.feature 'Registrations', js: true do
  scenario 'signing up with valid details' do
    visit '/'

    expect(page).to have_link 'Sign up'

    click_link 'Sign up'

    fill_in 'Name',             with: 'New User'
    fill_in 'Email',            with: 'new_user@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'password'

    click_button 'Register'

    expect(page).not_to have_text 'Sign up'

    # expect(page).to have_content 'new_user@example.com'

    expect(page).not_to have_link 'Sign up'
  end

  scenario 'signing up with invalid details' do
    visit '/'

    click_link 'Sign up'

    fill_in 'Email',            with: 'INVALID'
    fill_in 'Password',         with: 'SHORT'

    click_button 'Register'

    within '#errors' do
      expect(page).to have_text 'Registration cannot be completed!'
      expect(page).to have_text 'Email is not an email'
      expect(page)
        .to have_text 'Password is too short (minimum is 8 characters)'
    end

    fill_in 'Email',            with: 'valid_email@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'MISMATCH'

    click_button 'Register'

    within '#errors' do
      expect(page).to have_text "Password confirmation doesn't match Password"
    end
  end

  scenario 'signing in with an email that has already been registered' do
    registered_email = 'existing_user@example.com'
    password = 'password'

    User.create email: registered_email, password: password

    visit '/'

    click_link 'Sign up'

    fill_in 'Email',            with: registered_email
    fill_in 'Password',         with: password
    fill_in 'Confirm password', with: password

    click_button 'Register'

    within '#errors' do
      expect(page).to have_text 'Email address is already in use'
    end
  end
end
