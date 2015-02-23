require 'capybara'
require 'selenium-webdriver'

module Utils
  class DriverInit

    def self.driver
      # Local drivers registration
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

        # Remote driver registration
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

          Utils.logger.debug "remote_capabilities: #{remote_capabilities}"

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

      default_driver.to_sym
    end

  end
end