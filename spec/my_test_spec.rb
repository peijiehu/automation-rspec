require_relative 'my_pages'

describe 'Rent home page', :type => :feature, :js => true do

  EMAIL = 'qarent.h1@gmail.com'
  PASSWORD = 'qarent123'

  before :all do
  end

  before :each do
    @hp = MyPages::Home.new
    @hp.load
    @hp.wait_for_header(5)
  end

  it 'should have header' do
    expect(@hp).to have_header
  end

  it 'sign an existing renter in' do
    sign_in_overlay = @hp.header.click_link_sign_in
    li_hp = sign_in_overlay.sign_in_with(EMAIL, PASSWORD)
    expect(li_hp.signed_in_as).to eq(EMAIL)
  end

end