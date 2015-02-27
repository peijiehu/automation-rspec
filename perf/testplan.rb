require 'rubygems'
require 'ruby-jmeter'

def thread_count
  ENV['THREAD_COUNT'] || 10
end

def loop_count
  ENV['LOOP_COUNT'] || 5
end

def rampup_time
  ENV['RAMPUP_TIME'] || 1
end

def server_env
  ENV['SERVER_ENV'] || 'http://www.google.com'
end

test do
  threads count: thread_count, loop: loop_count, rampup: rampup_time do
    visit name: 'Google Search Home Page', url: server_env
  end
end.run(
    log: 'logs/jmeter.log',
    jtl: "reports/perf_result_#{Time.now.strftime("%Y%m%dT%H%M")}.jtl")