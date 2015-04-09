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

# By default, Capybara uses the :rack_test driver
# Capybara.default_driver = :selenium

# set default js enabled driver based on user input(env variable),
# which applies to all tests marked with :type => :feature
# default is :selenium, and selenium uses :firefox by default
driver_helper = Utils::DriverHelper.new
driver_to_use = driver_helper.driver
Capybara.javascript_driver = driver_to_use

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
      driver_helper.set_sauce_session_name(example_full_description) if driver_to_use.to_s.include?('saucelabs') && !driver_to_use.nil?
      Utils.logger.debug "Finished setting saucelabs session name for #{example_full_description}"
    rescue
      Utils.logger.debug "Failed setting saucelabs session name for #{example_full_description}"
    end
    # puts spec_dir = File.dirname(example.metadata[:file_path])
    run_before
  end

  config.append_after :each do |example|
    # do something right after each example's executed
    # Capybara.current_session.driver will give you the current driver
    # DatabaseCleaner.clean could be used here
    execution_result = example.metadata[:example_group][:execution_result].status
    # todo may need custom reporter to get status since status isn't set until all afters are run
  end

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  # config.filter_run :focus
  # config.run_all_when_everything_filtered = true

  # causes spec to fail, haven't inspected yet
  # config.disable_monkey_patching!

  # config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies
  # seed is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
