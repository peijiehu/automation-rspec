module Helper
  attr_accessor :email, :password, :hp, :new_email
  def run_before
    @new_email = generate_new_email
    # Read EMAIL and PASSWORD from config/accounts.yml
    accounts_yml = YAML.load_file("#{Dir.pwd}/config/accounts.yml")
    @email = accounts_yml['Renter']['Email']
    @password = accounts_yml['Renter']['Password']
    @hp = Home.new
  end

end