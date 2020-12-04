# frozen_string_literal: true

require_relative './file_helper'

module PassportProcessing
  class << self
    MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze

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
