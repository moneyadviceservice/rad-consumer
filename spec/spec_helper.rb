ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Faker::Config.locale = 'en-GB'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.example_status_persistence_file_path = '.spec/test_status.txt'
end
