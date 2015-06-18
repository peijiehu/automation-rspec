# Base page object
class Base < SitePrism::Page

  def current_url
    page.driver.current_url.downcase
  end

end