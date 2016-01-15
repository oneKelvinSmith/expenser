require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

DotEnv.Railtie.load

module Expenser
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    config.active_record.schema_format = :sql

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i(get post patch put delete options)
      end
    end

    config.api_only = false
  end
end
