describe 'home page search', :type => :feature, :js => true, :smoke => true do

  before :each do
    @hp = Home.new
  end

  it 'goes to SRP' do
    srp = @hp.hp_search('Los Angeles, CA')
  end

end