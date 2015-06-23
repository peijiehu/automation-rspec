module Utils
  module PageHelperModule

    def current_session
      Capybara.current_session
    end

    # Wait on all DOM events to finish
    # Note that #find(from Capybara::Node::Finders) continuously retry finding an element
    # and timeout for #find is controlled by Capybara.default_wait_time
    def wait_for_dom
      uuid = SecureRandom.uuid
      current_session.find("body")
      current_session.evaluate_script <<-EOS
        _.defer(function() {
          $('body').append("<div id='#{uuid}'></div>");
        });
      EOS
      current_session.find("div##{uuid}")
    end

    # Wait on all AJAX requests to finish
    def wait_for_ajax(timeout = Capybara.default_wait_time)
      wait(timeout: timeout, msg: "Timeout after waiting #{timeout} for all ajax requests to finish") do
        current_session.evaluate_script 'jQuery.active == 0'
      end
    end

    # Explicitly wait for a certain condition to be true:
    #   wait.until { driver.find_element(:css, 'body.tmpl-srp') }
    # when timeout is not specified, default timeout 5 sec will be used
    # when timeout is larger than 15, max timeout 15 sec will be used
    def wait(opts = {})
      if !opts[:timeout].nil? && opts[:timeout] > 15
        puts "WARNING: #{opts[:timeout]} sec timeout is NOT supported by wait method,
                max timeout 15 sec will be used instead"
        opts[:timeout] = 15
      end
      Selenium::WebDriver::Wait.new(opts)
    end

  end
end