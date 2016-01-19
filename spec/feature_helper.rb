require 'rails_helper'

require 'capybara'
require 'capybara/rspec'

module Features
  module AuthHelpers
    def login(user)
      visit '/'

      click_link 'Log in'

      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password

      click_button 'Log in'
    end

    def logout
      visit '/'

      click_button 'Log out'
    end
  end

  module TimeHelpers
    def now
      DateTime.now
    end

    def formatted_datetime(datetime)
      datetime.strftime('%B %e %Y at %H:%M')
    end

    def formatted_date(datetime)
      datetime.strftime('%B %e %Y')
    end

    def formatted_time(datetime)
      datetime.strftime('%l:%M %P').strip
    end
  end
end

Capybara.javascript_driver = :webkit
#  Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include Features::AuthHelpers, type: :feature
  config.include Features::TimeHelpers, type: :feature
end
