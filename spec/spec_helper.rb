require 'rubygems'
require 'capybara'
require 'capybara/rspec'
require 'site_prism'
require 'yaml'
require 'pry'

require 'page_objects/all_page_objects'
require 'utils/all_utils'

Capybara.run_server = false
Capybara.default_wait_time = 10

# set default js enabled driver based on user input(env variable),
# which applies to all tests marked with :type => :feature
# default is :selenium, and selenium uses :firefox by default
driver_helper = Utils::DriverHelper.new("#{Dir.pwd}/config/driver/saucelabs.yml")
driver_to_use = driver_helper.driver
Capybara.javascript_driver = driver_to_use.to_sym

# sets app_host based on user input(env variable)
app_host = ENV['r_env'] || begin
  Utils.logger.debug "r_env is not set, using default env 'qa'"
  'qa'
end
env_yaml = YAML.load_file("#{Dir.pwd}/config/env.yml")
Capybara.app_host = env_yaml[app_host]

RSpec.configure do |config|

  config.before :each do |example|
    example_full_description = example.full_description
    Utils.logger.debug "example full description: #{example_full_description}"
    begin
      driver_helper.set_sauce_session_name(example_full_description) if driver_to_use.include?('saucelabs') && !driver_to_use.nil?
      Utils.logger.debug "Finished setting saucelabs session name for #{example_full_description}"
    rescue
      Utils.logger.debug "Failed setting saucelabs session name for #{example_full_description}"
    end
    # puts spec_dir = File.dirname(example.metadata[:file_path])
    page.driver.allow_url '*' if driver_to_use == 'webkit'
    begin
      run_before
    rescue NameError
      true
    end
  end

  config.append_after :each do |example|
    # do something right after each example's executed
    # DatabaseCleaner.clean could be used here
    execution_result = example.metadata[:example_group][:execution_result].status
    # todo may need custom reporter to get status since status isn't set until all afters are run
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # causes spec to fail, haven't inspected yet
  # config.disable_monkey_patching!

  # config.warnings = true

  # allow more verbose output when running an individual spec file.
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
