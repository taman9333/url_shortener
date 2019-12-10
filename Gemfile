source 'https://rubygems.org'

gem 'pg'
gem 'rake' # to run rake tasks
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'thin'

group :development do
  # reload sinatra app on changes
  gem 'rerun'
end

group :test, :development do
  gem 'byebug'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'shoulda-matchers'
end
