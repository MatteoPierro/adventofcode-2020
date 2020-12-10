# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/10

module AdapterArray
  class << self
    def multiply_differences(adapters)
      differences = find_differences(adapters)
      differences.count(1) * differences.count(3)
    end

    def find_combinations(adapters)
      find_differences(adapters)
        .chunk { |difference| difference != 1 }
        .filter { |chunk| !chunk.first }
        .map { |chunk| chunk.last.length + 1 } # +1 because you need to reach the next hop
        .map { |sequence_length| find_sequence_combination(sequence_length) }
        .reduce(:*)
    end

    private

    def find_sequence_combination(sequence_length, current = 1)
      return 1 if current == sequence_length

      return 0 if current > sequence_length

      find_sequence_combination(sequence_length, current + 1) +
        find_sequence_combination(sequence_length, current + 2) +
        find_sequence_combination(sequence_length, current + 3)
    end

    def find_differences(adapters)
      adapters << 0
      adapters << adapters.max + 3
      adapters.sort.each_cons(2).map { |a, b| b - a }
    end
  end
end
