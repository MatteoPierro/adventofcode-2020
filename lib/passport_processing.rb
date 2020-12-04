# frozen_string_literal: true

require_relative './file_helper'

module PassportProcessing
  MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze

  SIMPLE_VALIDATOR = lambda do |passport|
    (MANDATORY_FIELDS - passport.scan(/(\w+):\S+/).flatten).empty?
  end

  COMPLETE_VALIDATOR = lambda do |raw_passport|
    return false unless SIMPLE_VALIDATOR.call(raw_passport)

    passport = raw_passport.scan(/(\w+):(\S+)/).each_with_object({}) do |field, p|
      p[field.first.to_s] = field.last
    end

    return passport[:byr].to_i >= 1920 && passport[:byr].to_i <= 2002
  end

  class << self
    def count_valid_passports(passport_filepath = nil, validator = SIMPLE_VALIDATOR)
      passport_filepath ||= './lib/passport_processing.txt'
      parse(passport_filepath)
        .filter { |passport| validator.call(passport) }
        .count
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
