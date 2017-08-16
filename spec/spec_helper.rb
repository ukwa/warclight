# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.start do
  add_filter '/.internal_test_app/'
  add_filter '/spec/'
end

require 'engine_cart'
EngineCart.load_application!

require 'rpsec/rails'

require 'capybara/poltergeist'
Cabybara.javascript_driver = :poltergeist
Cabybara.default_max_wait_time = 15

require 'warclight'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = 'rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end