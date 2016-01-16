require 'feature_helper'

RSpec.feature 'Signup', js: true do
  scenario 'with valid details' do
    visit '/'

    expect(page).to have_link 'Sign up'

    click_link 'Sign up'

    fill_in 'Email',            with: 'new_user@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'password'

    click_button 'Sign up'

    expect(page).to have_text 'Welcome to the Expenser'

    expect(page).not_to have_text 'Sign up'
    expect(page).not_to have_link 'Sign up'

    click_button 'Log out'
  end

  scenario 'with invalid details' do
    visit '/'

    click_link 'Sign up'

    fill_in 'Email',            with: 'INVALID'
    fill_in 'Password',         with: 'SHORT'

    click_button 'Sign up'

    within '#errors' do
      expect(page).to have_text 'Registration cannot be completed!'
      expect(page).to have_text 'Email is invalid'
      expect(page)
        .to have_text 'Password is too short (minimum is 8 characters)'
    end

    fill_in 'Email',            with: 'valid_email@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'MISMATCH'

    click_button 'Sign up'

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

    click_button 'Sign up'

    within '#errors' do
      expect(page).to have_text 'Email has already been taken'
    end
  end
end
