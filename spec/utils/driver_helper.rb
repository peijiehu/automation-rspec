require 'capybara'
require 'selenium-webdriver'
require 'rest-client'

module Utils
  class DriverHelper

    attr_accessor :user, :pass, :driver_to_use

    def driver
      # Local drivers registration
      local_drivers = [:firefox, :chrome]
      local_drivers.each do |driver|
        Capybara.register_driver driver do |app|
          Capybara::Selenium::Driver.new(app, :browser => driver)
        end
      end

      if ENV['r_driver'].nil?
        # set default_driver to a local firefox
        driver_to_use = 'firefox'
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
            self.user = remote_driver_yaml['hub']['user']
            self.pass = remote_driver_yaml['hub']['pass']
            remote_capabilities = {
                'browserName' => 'firefox',
                'version' => '34',
                'platform' => 'Windows 7'
            }
          else
            # set by overrides
            self.user = overrides_hash[cmd_r_driver[1]]['hub']['user']
            self.pass = overrides_hash[cmd_r_driver[1]]['hub']['pass']
            remote_capabilities = overrides_hash[cmd_r_driver[2]]['capabilities']
          end

          Utils.logger.debug "remote_capabilities: #{remote_capabilities}"

          default_remote_options = {
              :browser => :remote,
              :url => "http://#{self.user}:#{self.pass}@ondemand.saucelabs.com/wd/hub",
              :desired_capabilities => remote_capabilities
          }
          Capybara.register_driver :saucelabs do |app|
            Capybara::Selenium::Driver.new(app, default_remote_options)
          end
        end
        # set default_driver to a local browser or saucelabs
        driver_to_use = cmd_r_driver[0]
      end

      driver_to_use = driver_to_use.to_sym
      driver_to_use
    end


    # update session name on saucelabs
    def set_sauce_session_name(new_name)
      new_tags = "started by #{self.user}"
      require 'json'
      # current session is a wrapper of Capybara::Selenium::Driver,
      # Capybara::Selenium::Driver instantiates a browser from Selenium::Webdriver
      # then bridge is a private method in Selenium::Webdriver::Driver
      bridge = Capybara.current_session.driver.browser.send :bridge
      session_id = bridge.session_id
      Utils.logger.debug "bridge session_id: #{session_id}"
      http_auth = "https://#{self.user}:#{self.pass}@saucelabs.com/rest/v1/#{self.user}/jobs/#{session_id}"
      # to_json need to: require "active_support/core_ext", but will mess up the whole framework, require 'json' in this method solved it
      body = {"name" => new_name, "tags" => [new_tags]}.to_json
      # gem 'rest-client'
      Utils.logger.debug "About to send request to saucelabs with url as #{http_auth} and body as #{body}"
      RestClient.put(http_auth, body, {:content_type => "application/json"})
    end

  end
end