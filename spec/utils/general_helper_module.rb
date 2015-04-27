module Utils
  module GeneralHelperModule

    # Generate a unique id with a random hex string and time stamp string
    def generate_unique_id
      SecureRandom.hex(3) + Time.now.to_i.to_s
    end

    def generate_new_email
      [generate_unique_id, 'pj@mailinator.com'].join('.')
    end

  end
end