require 'rails_helper'

require 'capybara'
require 'capybara/rspec'

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end
end
