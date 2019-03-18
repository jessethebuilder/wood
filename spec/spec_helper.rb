require 'capybara/rspec'
require 'capybara/poltergeist'
require 'factory_bot_rails'
require 'vcr'

VCR.configure do |config|
  # config.cassette_library_dir = "#{Rails.root}/spec/fixtures/vcr_cassettes"
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

Capybara.javascript_driver = :poltergeist

require 'mongoid-rspec'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Mongoid::Matchers, type: :model

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.include FactoryBot::Syntax::Methods

  # config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
