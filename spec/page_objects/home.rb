require_relative 'sections/header_section'
# HomePage
class Home < Base
  set_url '/'
  section :header, HeaderSection, 'div#signin-container'
end