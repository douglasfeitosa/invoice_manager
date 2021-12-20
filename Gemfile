source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.6.0'

gem 'rails', '~> 6.0.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem "warden", "~> 1.2"
gem "jquery-rails", "~> 4.4"
gem "sidekiq", "~> 6.3"
gem "dotenv-rails", "~> 2.7"
gem "wicked_pdf", "~> 2.1"
gem "wkhtmltopdf-binary", "~> 0.12.6"
gem "webpacker", "~> 5.4"
gem "pdf-inspector", "~> 1.3"
gem "jquery-ui-rails", "~> 6.0"
gem 'bootstrap', '~> 5.1', '>= 5.1.3'

group :development do
  gem "better_errors", "~> 2.9"
  gem "binding_of_caller", "~> 1.0"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.19'
  gem "pry", "~> 0.14.1"
  gem 'rspec-rails', '~> 5.0'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem "rails-controller-testing", "~> 1.0"
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', '~> 0.21.2', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

