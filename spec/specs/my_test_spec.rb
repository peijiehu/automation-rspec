describe 'home page', :type => :feature, :js => true, :smoke => true do

  before :each do |example|
    # Read EMAIL and PASSWORD from config/accounts.yml
    accounts_yml = YAML.load_file("#{Dir.pwd}/config/accounts.yml")
    EMAIL = accounts_yml['Renter']['Email']
    PASSWORD = accounts_yml['Renter']['Password']
    @hp = Home.new
    Utils.logger.debug "example: #{example.description}"
  end

  it 'sign an existing renter in', :slow, :random_tag do |example|
    # this expect is just to show off you can use 'example' in a lot of places
    expect(example.description).to eq('sign an existing renter in')
    expect(@hp).to have_lo_header
    sign_in_overlay = @hp.lo_header.click_link_sign_in
    li_srp = sign_in_overlay.sign_in_with(EMAIL, PASSWORD)
    expect(li_srp.li_header.signed_in_as).to eq(EMAIL)
  end

  it 'test skip', :test_skip, :skip => 'test spec, need to remove' do
    expect(true).to eq(false)
  end

end