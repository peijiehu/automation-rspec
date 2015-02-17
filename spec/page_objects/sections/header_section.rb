# Header section
class HeaderSection < SitePrism::Section
  element :link_reg, "span#sign-in-reg a[href='#']"
  element :link_sign_in, "a#signin-text"
  element :signed_in_email, 'a#mast-acct-nav-toggle span#acct-email'

  def click_link_sign_in
    link_sign_in.click
    SignIn.new
  end

  def signed_in_as
    signed_in_email.text
  end

end