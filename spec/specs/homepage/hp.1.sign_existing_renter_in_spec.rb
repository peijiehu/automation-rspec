require_relative 'helper'
include Helper
describe 'Homepage.HP.1', :type => :feature, :js => true, :smoke => true do
  it 'sign an existing renter in', :slow do |example|
    # this expect is just to show off you can use 'example' in a lot of places
    expect(example.description).to eq('sign an existing renter in')
    expect(@hp).to have_lo_header
    sign_in_overlay = @hp.lo_header.click_link_sign_in
    li_srp = sign_in_overlay.sign_in_with(@email, @password)
    expect(li_srp.li_header.signed_in_as).to eq(@email)
  end
end