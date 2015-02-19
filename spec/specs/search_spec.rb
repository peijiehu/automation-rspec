describe 'home page search', :type => :feature, :js => true do

  before :each do
    @hp = Home.new
    @hp.load
    @hp.wait_for_lo_header(5)
  end

  it 'goes to SRP' do
    srp = @hp.hp_search('Los Angeles, CA')
  end

end