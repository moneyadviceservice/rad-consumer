VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Allow access to Elastic Search running locally
  config.ignore_localhost = true
end

def vcr_options_for_feature(cassette_name)
  { cassette_name: cassette_name, record: :new_episodes }
end

RSpec.configure do |config|
  config.around(:each, :localhost_vcr) do |example|
    raise 'Cannot use :localhost_vcr since VCR is off' unless VCR.turned_on?
    VCR.configuration.ignore_localhost = false
    example.run
    VCR.configuration.ignore_localhost = true
  end
end
