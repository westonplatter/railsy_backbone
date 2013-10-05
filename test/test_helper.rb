# Configure Rails Environment
ENV["RAILS_ENV"] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# For Generators
require 'rails/generators/test_case'

require 'mocha/setup'

require 'capybara/dsl'
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
