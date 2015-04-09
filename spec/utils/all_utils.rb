Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
require 'active_support/inflector'
Dir[File.dirname(__FILE__) + '/*_module.rb'].each do |file|
  camelized_file = File.basename(file, '.rb').camelize
  autoload(camelized_file.to_sym, file)
  include Utils.const_get(camelized_file)
end
