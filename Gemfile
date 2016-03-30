source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.1.0.rc1'
gem 'rails'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use Capistrano for deployment
group :development do
  gem 'capistrano-bundler', :require => false
  gem 'capistrano-rails', :require => false
  gem 'capistrano', :require => false
  gem 'capistrano-fiftyfive', :require => false
  gem 'sshkit', github: 'capistrano/sshkit'
  gem 'highline'
end

gem 'pg'

gem 'monetize'
gem 'money'
gem 'sentient_user'
gem 'nested_form'
gem 'prawn'
gem 'simple_form'
gem 'haml'
gem 'haml-rails'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'country_select'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# Use unicorn as the web server
gem 'unicorn'

gem 'therubyracer', :platforms => :ruby
gem 'bootstrap-sass'
# gem 'jquery-ui-rails'

group :test do
  gem 'minitest'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'pry-rails'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
end
