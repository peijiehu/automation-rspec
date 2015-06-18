# Google home page
class SearchEngineHome < Base

  set_url '/'

  element :g_search_input_field, 'input#lst-ib'
  element :g_search_submit_button, "button.lsb[type='submit']"

  element :d_search_input_field, 'input#search_form_input_homepage'
  element :d_search_submit_button, "input#search_button_homepage[type='submit']"

  def initialize
    load
  end

  def google_search(term)
    g_search_input_field.set term
    g_search_submit_button.click
    Serp.new
  end

  def duck_search(term)
    d_search_input_field.set term
    d_search_submit_button.click
    Serp.new
  end

end