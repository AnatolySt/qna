require_relative 'rails_helper'
require "selenium/webdriver"

RSpec.configure do |config|
  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.server = :puma

  config.include AcceptanceMacros, type: :feature
  config.include OmniauthMacros

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each, js: true) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true