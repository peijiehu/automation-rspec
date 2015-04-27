# Header section
class LoHeaderSection < SitePrism::Section
  element :link_reg, "span#sign-in-reg a[href='#']"
  element :link_sign_in, "a#signin-text"

  def click_link_sign_in
    link_sign_in.click
    SignIn.new
  end

  def click_link_reg
    link_reg.click
    Registration.new
  end

end