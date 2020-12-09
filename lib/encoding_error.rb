# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/9

class EncodingError
  class << self
    def encryption_weakness(sequence:, target:)
      (0...sequence.length).to_a
                           .map { |index| sequence[index..] }
                           .map { |s| find_limits(s, target) }
                           .find { |l| l.length > 1 && l.sum == target }
                           .tap do |s|
        s.sort!
        return s.first + s.last
      end
    end

    def find_limits(sequence, target)
      sum = 0
      sequence.take_while do |value|
        sum += value
        sum <= target
      end
    end

    def find_error(sequence:, preamble_length: 25)
      sequence.each_cons(preamble_length + 1).find do |*preamble, number|
        combination = find_valid_combination(preamble, number)
        return number if combination.nil?
      end
    end

    private

    def find_valid_combination(preamble, number)
      preamble.combination(2).find do |a, b|
        a + b == number
      end
    end
  end
end
