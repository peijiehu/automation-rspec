require 'rubygems'
require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'yaml'
require 'active_support'

require 'page_objects/all_page_objects'

# Logging
module Utils

  class Logger < ActiveSupport::Logger
    def initialize
      log_file_path = "#{Dir.pwd}/logs/rspec.log"
      log_file = File.open(log_file_path, File::WRONLY | File::APPEND | File::CREAT) unless log_file_path.respond_to?(:write)
      super(log_file)
    end
  end

  def self.logger
    logger = Logger.new
    my_format = "[%s#%d] %5s -- %s: %s\n"
    original_formatter = Logger::Formatter.new
    logger.formatter = proc { |severity, datetime, progname, msg|
      formatted_datetime = original_formatter.send :format_datetime, datetime
      str_msg = original_formatter.send :msg2str, msg
      my_format % [formatted_datetime, $$, severity, progname, str_msg]
    }
    logger
  end

end

Capybara.run_server = false
Capybara.default_wait_time = 10

# By default, Capybara uses the :rack_test driver, which is fast
# but limited: it does not support JavaScript,
# nor is it able to access HTTP resources outside of your Rack application
# But still, keep the default as :rack_test
# and only tag the tests that need js with :js => true
# to have overall best performance for entire suite
# Capybara.default_driver = :selenium


# local drivers registration
local_drivers = [:firefox, :chrome]
local_drivers.each do |driver|
  Capybara.register_driver driver do |app|
    Capybara::Selenium::Driver.new(app, :browser => driver)
  end
end

if ENV['r_driver'].nil?
  # set default_driver to a local firefox
  default_driver = 'firefox'
else
  # cmd_r_driver may be 'chrome' or ['saucelabs', 'phu', 'win7_ff34'], etc
  cmd_r_driver = ENV['r_driver'].split(':')
  # remote driver registration
  # Retrieve hub url, user credentials and browser info from saucelabs.yml
  if ENV['r_driver'].include?('saucelabs')
    remote_driver_yaml = YAML.load_file("#{Dir.pwd}/config/driver/saucelabs.yml")
    remote_capabilities = Selenium::WebDriver::Remote::Capabilities.new
    overrides_hash = remote_driver_yaml['overrides']
    if cmd_r_driver[1].nil?
      # set default
      user = remote_driver_yaml['hub']['user']
      pass = remote_driver_yaml['hub']['pass']
      remote_capabilities = {
          'browserName' => 'firefox',
          'version' => '34',
          'platform' => 'Windows 7'
      }
    else
      # set by overrides
      user = overrides_hash[cmd_r_driver[1]]['hub']['user']
      pass = overrides_hash[cmd_r_driver[1]]['hub']['pass']
      remote_capabilities = overrides_hash[cmd_r_driver[2]]['capabilities']
    end

    Utils.logger.debug remote_capabilities

    default_remote_options = {
        :browser => :remote,
        :url => "http://#{user}:#{pass}@ondemand.saucelabs.com/wd/hub",
        :desired_capabilities => remote_capabilities
    }
    Capybara.register_driver :saucelabs do |app|
      Capybara::Selenium::Driver.new(app, default_remote_options)
    end
  end
  # set default_driver to a local browser or saucelabs
  default_driver = cmd_r_driver[0]
end

# set default js enabled driver based on user input(env variable),
# which applies to all tests marked with :type => :feature
# default is :selenium, and selenium uses :firefox by default
Capybara.javascript_driver = default_driver.to_sym

# sets app_host based on user input(env variable)
app_host = ENV['r_env'] || begin
  Utils.logger.debug "r_env is not set, using default env 'qa'"
  'qa'
end
env_yaml = YAML.load_file("#{Dir.pwd}/config/env.yml")
Capybara.app_host = env_yaml[app_host]

RSpec.configure do |config|

  # quit driver right after each example's executed
  config.after :each do
    Capybara.current_session.driver.quit
  end

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
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

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
