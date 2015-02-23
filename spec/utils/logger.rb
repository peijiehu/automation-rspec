require 'active_support'

module Utils

  # Logging
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