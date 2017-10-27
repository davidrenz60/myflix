source 'https://rubygems.org'
ruby '2.2.8'

gem 'bcrypt-ruby'
gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.9'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg', '0.20'
gem 'eventmachine', '1.0.4'
gem 'json', '1.8.6'
gem 'sidekiq', '< 5'
gem 'unicorn'
gem 'sentry-raven'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '3.5'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner', '1.4.1'
  gem 'fabrication'
  gem 'faker'
  gem 'launchy'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3'
end

group :production, :staging do
  gem 'rails_12factor'
end

