# Header section
class LiHeaderSection < SitePrism::Section
  element :signed_in_email, 'span.acct-email'

  def signed_in_as
    signed_in_email.text
  end

end