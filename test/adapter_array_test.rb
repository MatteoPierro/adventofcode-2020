# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/adapter_array'

class AdapterArrayTest < Minitest::Test
  def test_multiply_differences
    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    adapter_array = AdapterArray.new(adapters)

    assert_equal(35, adapter_array.multiply_differences)
  end

  def test_first_puzzle
    adapter_array = AdapterArray.from_file('./lib/adapter_array.txt')

    assert_equal(2380, adapter_array.multiply_differences)
  end

  def test_find_combinations
    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    adapter_array = AdapterArray.new(adapters)

    assert_equal(8, adapter_array.count_combinations)
  end

  def test_second_puzzle
    adapter_array = AdapterArray.from_file('./lib/adapter_array.txt')

    assert_equal(48_358_655_787_008, adapter_array.count_combinations)
  end
end
