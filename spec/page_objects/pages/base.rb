# Base page object
class Base < SitePrism::Page

  def initialize
    wait_for_ajax
  end

end