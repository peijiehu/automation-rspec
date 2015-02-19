# HomePage
class Home < Base
  set_url '/'
  section :lo_header, LoHeaderSection, 'div#signin-container'
  section :li_header, LiHeaderSection, 'a#mast-acct-nav-toggle'
  element :search_input_field, 'div.field-wrapper input#freeform_submarket_nm'
  element :search_submit_button, 'div.field-wrapper button.cancel'

  def hp_search(search_input)
    search_input_field.set search_input
    search_submit_button.click
    Srp.new
  end
end