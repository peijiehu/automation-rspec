describe 'Rent home page', :type => :feature, :js => true do

  # Read EMAIL and PASSWORD from config/accounts.yml
  accounts_yml = YAML.load_file("#{Dir.pwd}/config/accounts.yml")
  EMAIL = accounts_yml['Renter']['Email']
  PASSWORD = accounts_yml['Renter']['Password']

  before :all do
  end

  before :each do
    @hp = Home.new
    @hp.load
    @hp.wait_for_lo_header(5)
  end

  it 'should have header' do
    expect(@hp).to have_lo_header
  end

  it 'sign an existing renter in' do
    sign_in_overlay = @hp.lo_header.click_link_sign_in
    li_srp = sign_in_overlay.sign_in_with(EMAIL, PASSWORD)
    expect(li_srp.li_header.signed_in_as).to eq(EMAIL)
  end

end