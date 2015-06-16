class Simple < Tourist
  HOST = "http://www.google.com"
  def tour_homepage
    visit HOST
    assert_contain "My Home Page"
  end
end
