source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'rails-api', '~> 0.4.0'
gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git', tag: 'v0.10.0.rc3'

gem 'devise_token_auth', '~> 0.1.36'

gem 'ember-cli-rails', '~> 0.7.0'

gem 'pg', '~> 0.18.4'
gem 'puma', '~> 2.15.3'
gem 'dotenv-rails', '~> 2.0.2'

group :development do
  gem 'awesome_print', '~> 1.6.1'
  gem 'pry-rails', '~> 0.3.4'
  gem 'spring', '~> 1.6.2'
end

group :development, :test do
  gem 'rubocop', '~> 0.35.1'
  gem 'foreman', '~> 0.78.0'
  gem 'pry', '~> 0.10.3'
  gem 'simplecov', '>= 0.10.0', require: false
end

group :test do
  gem 'rspec-rails', '~> 3.4.0'
  gem 'capybara', '~> 2.5.0'
  gem 'capybara-webkit', '~> 1.7.1'
  gem 'database_cleaner', '~> 1.5.1'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end
