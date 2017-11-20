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
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'draper'
gem 'stripe_event'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

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
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'launchy'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '3.0.1'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'carrierwave-aws'
  gem 'rails_12factor'
end

