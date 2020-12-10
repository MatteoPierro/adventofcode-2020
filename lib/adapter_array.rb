# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/10

class AdapterArray
  attr_reader :adapters

  def initialize(adapters)
    @adapters = adapters
    @adapters << 0
    @adapters << adapters.max + 3
  end

  def multiply_differences
    find_differences_value = adapters.sort.each_cons(2).map { |a, b| b - a }
    differences = find_differences_value
    differences.count(1) * differences.count(3)
  end

  # rubocop:disable Metrics/MethodLength
  def count_combinations(target = adapters.max + 3, current = 0, memo = {})
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
                    .map { |inc| count_combinations(target, current + inc, memo) }
                    .sum
    memo[current]
  end
  # rubocop:enable Metrics/MethodLength
end
