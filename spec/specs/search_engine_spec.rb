describe :search_engine, :type => :feature, :js => true, :smoke => true do

  before :each do
    @hp = SearchEngineHome.new
  end

  it 'goes to results page of duck', :name => :duck_search do
    serp = @hp.duck_search('Los Angeles, CA')
    expect(serp.current_url.downcase).to eq("https://duckduckgo.com/?q=los+angeles%2c+ca&ia=about")
  end

  it 'goes to results page of duck copy', :duck_search_copy do
    serp = @hp.duck_search('Los Angeles, CA')
    expect(serp.current_url.downcase).to eq("https://duckduckgo.com/?q=los+angeles%2c+ca&ia=about")
  end

  it :location_search, :serial => :SRP_1 do
    serp = @hp.duck_search('Los Angeles, CA')
    expect(serp.current_url.downcase).to eq("https://duckduckgo.com/?q=los+angeles%2c+ca&ia=about")
  end

end