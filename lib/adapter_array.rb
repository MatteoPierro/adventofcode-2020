# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/10

class AdapterArray
  def self.from_file(file_path)
    adapters = File.readlines(file_path).map(&:to_i)
    new(adapters)
  end

  attr_reader :adapters

  def initialize(adapters)
    @adapters = [0, *adapters, adapters.max + 3]
  end

  def multiply_differences
    differences = adapters.sort.each_cons(2).map { |a, b| b - a }
    differences.count(1) * differences.count(3)
  end

  def count_combinations(target = adapters.max, current = 0, memo = {})
    return memo[current] if memo.include?(current)
    return 1 if current == target
    return 0 unless adapters.include?(current)

    memo[current] = (1..3)
                    .each
                    .map { |inc| count_combinations(target, current + inc, memo) }
                    .sum
  end
end
