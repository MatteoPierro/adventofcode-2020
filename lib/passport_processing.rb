module PassportProcessing
  class << self
    MANDATORY_FIELDS = %w(byr iyr eyr hgt hcl ecl pid)

    def valid?(passport)
      (MANDATORY_FIELDS - passport.scan(/(\w+):\S+/).flatten).empty?
    end
  end
end