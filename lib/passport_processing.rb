# frozen_string_literal: true

require_relative './file_helper'

module PassportProcessing
  class << self
    MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze

    def count_valid_passports(passport_filepath)
      parse(passport_filepath).filter(&method(:valid?)).count
    end

    def valid?(passport)
      (MANDATORY_FIELDS - passport.scan(/(\w+):\S+/).flatten).empty?
    end

    def parse(filepath)
      File.readlines(filepath)
          .chunk(&:empty?)
          .map { |_, v| v.join(' ') }
          .reject(&:empty?)
          .to_a
    end
  end
end
