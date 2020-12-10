# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/adapter_array'

class AdapterArrayTest < Minitest::Test
  def test_multiply_differences
    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    assert_equal(35, AdapterArray.multiply_differences(adapters))
  end

  def test_first_puzzle
    adapters = File.readlines('./lib/adapter_array.txt').map(&:to_i)
    assert_equal(2380, AdapterArray.multiply_differences(adapters))
  end

  def test_find_combinations
    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    assert_equal(8, AdapterArray.find_combinations(adapters))
  end

  def test_second_puzzle
    adapters = File.readlines('./lib/adapter_array.txt').map(&:to_i) << 0
    assert_equal(48_358_655_787_008, AdapterArray.find_combinations(adapters))
  end
end
