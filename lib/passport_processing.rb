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
      p[field.first.to_sym] = field.last
    end

    return validate_range(passport[:byr], 1920, 2002) &&
           validate_range(passport[:iyr], 2010, 2020) &&
           validate_range(passport[:eyr], 2020, 2030) &&
           validate_height(passport[:hgt])
  end

  def self.validate_height(raw_height)
    height_parts = raw_height.scan(/(\d+)(cm|in)/).first
    return false if height_parts.nil?

    (value, scale) = height_parts
    if scale == 'cm'
      validate_range(value, 150, 193)
    else
      validate_range(value, 59, 76)
    end
  end

  def self.validate_range(value, lower_value, higher_value)
    (lower_value..higher_value).include? value.to_i
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
