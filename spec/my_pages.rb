module MyPages

  # Base page object
  class Base < SitePrism::Page
  end

  # Header section
  class HeaderSection < SitePrism::Section
    element :link_reg, "span#sign-in-reg a[href='#']"
    element :link_sign_in, "a#signin-text"
    element :signed_in_email, 'a#mast-acct-nav-toggle span#acct-email'

    def click_link_sign_in
      link_sign_in.click
      return SignIn.new
    end

    def signed_in_as
      signed_in_email.text
    end

  end

  # HomePage
  class Home < Base
    set_url '/'
    section :header, HeaderSection, 'div#signin-container'
  end

  # SignIn
  class SignIn < Base
    element :email_field, 'div#ar-signin-overlay form#ar-signin-form input#email_form_input'
    element :password_field, 'div#ar-signin-overlay form#ar-signin-form input#ar-u-password'
    element :sign_in_button, "div#ar-signin-overlay form#ar-signin-form button[type='submit']"
    def sign_in_with(email, password)
      email_field.set email
      password_field.set password
      sign_in_button.click
      return Home.new
    end
  end

end