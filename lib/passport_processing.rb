require_relative "./file_helper"

module PassportProcessing
  class << self
    MANDATORY_FIELDS = %w(byr iyr eyr hgt hcl ecl pid)

    def valid?(passport)
      (MANDATORY_FIELDS - passport.scan(/(\w+):\S+/).flatten).empty?
    end

    def parse(filepath)
      File.readlines(filepath)
      .chunk { |e| e.empty?  }
      .map { |k,v| v.join(" ")}
      .reject { |e| e.empty? }
      .to_a
    end
  end
end
