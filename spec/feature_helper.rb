require 'rails_helper'

require 'capybara'
require 'capybara/rspec'

module Features
  module AuthHelpers
    def login(user)
      visit '/login'

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Log in'
    end

    def logout
      visit '/'

      click_button 'Log out'
    end
  end
end

Capybara.javascript_driver = :webkit
Capybara.javascript_driver = :selenium if Rails.env == 'development'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include Features::AuthHelpers, type: :feature
end
