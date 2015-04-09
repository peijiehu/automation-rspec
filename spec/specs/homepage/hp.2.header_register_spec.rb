require_relative 'helper'
include Helper
describe 'Homepage.HP.2', :type => :feature, :js => true, :smoke => true do
  it 'register new renter', :slow, :focus, :random_tag do |example|
    expect(@hp).to have_lo_header
    reg_overlay = @hp.lo_header.click_link_reg
    li_srp = reg_overlay.reg_with(@new_email)
    expect(li_srp.li_header.signed_in_as).to eq(@new_email)
  end
end