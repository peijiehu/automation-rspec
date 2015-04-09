class Password < Base
  base_path = 'div#ar-signup-overlay form#ar-reg-form'
  element :email_field, [base_path, 'input#email_form_input'].join(' ')
  element :enter_button, [base_path, 'button#ar-dyn-submit-button'].join(' ')
  def reg_with(email)
    email_field.set email
    enter_button.click
    Srp.new
  end
end