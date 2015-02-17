# SignIn
class SignIn < Base
  element :email_field, 'div#ar-signin-overlay form#ar-signin-form input#email_form_input'
  element :password_field, 'div#ar-signin-overlay form#ar-signin-form input#ar-u-password'
  element :sign_in_button, "div#ar-signin-overlay form#ar-signin-form button[type='submit']"
  def sign_in_with(email, password)
    email_field.set email
    password_field.set password
    sign_in_button.click
    Home.new
  end
end