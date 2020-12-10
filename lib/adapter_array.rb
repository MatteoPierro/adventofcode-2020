# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/10

module AdapterArray
  class << self
    def multiply_differences(adapters)
      adapters << 0
      adapters << adapters.max + 3
      differences = adapters.sort.each_cons(2).map { |a, b| b - a }
      differences.count(1) * differences.count(3)
    end
  end
end
