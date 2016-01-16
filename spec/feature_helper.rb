require 'rails_helper'

require 'capybara'
require 'capybara/rspec'

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.use_transactional_fixtures = false
end
