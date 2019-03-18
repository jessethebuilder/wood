ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.before do
    config.include Devise::Test::ControllerHelpers, :type => :controller
    config.include Devise::Test::ControllerHelpers, :type => :helper
    # stub_request(:any, /\.uscourts\.gov\/cgi-bin\/rss_outside\.pl/).to_rack(FakePacerRss)
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
