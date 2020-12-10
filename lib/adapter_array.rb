# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/10

module AdapterArray
  class << self
    def multiply_differences(adapters)
      adapters << 0
      adapters << adapters.max + 3
      find_differences_value = adapters.sort.each_cons(2).map { |a, b| b - a }
      differences = find_differences_value
      differences.count(1) * differences.count(3)
    end

    # rubocop:disable Metrics/MethodLength
    def find_combinations(adapters, target = adapters.max + 3, current = 0, memo = {})
      return memo[current] if memo.include?(current)

      if current == target
        memo[current] = 1
        return 1
      end

      unless adapters.include?(current)
        memo[current] = 0
        return 0
      end

      memo[current] = (1..3)
                      .each
                      .map { |inc| find_combinations(adapters, target, current + inc, memo) }
                      .sum
      memo[current]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
