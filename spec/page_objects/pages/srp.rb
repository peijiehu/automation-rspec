# HomePage
class Srp < Base
  section :lo_header, LoHeaderSection, 'div#signin-container'
  section :li_header, LiHeaderSection, 'a#mast-acct-nav-toggle'
  element :search_input, 'form#search-form input#search-near'

  def validate
    wait_until_search_input_present
  end

end