# Load sections for pages, load all page objects for all specs

current_path = File.expand_path('..', __FILE__)

# order matters, load sections first so pages can be loaded
# letter s comes after p, so can't just do one File.join(current_path, '**', '*.rb')

Dir.glob(File.join(current_path, 'sections', '*.rb')).each do |f|
  require f
end

Dir.glob(File.join(current_path, 'pages', '*.rb')).each do |f|
  require f
end