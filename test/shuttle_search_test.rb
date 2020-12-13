# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shuttle_search'

class ShuttleSearchTest < Minitest::Test
  def test_find_departure
    time = 939
    buses = [7, 13, 59, 31, 19]
    departure = ShuttleSearch.find_departure(time, buses)
    assert_equal(ShuttleSearch::Departure.new(59, 944), departure)
  end

  def test_minutes_to_wait
    assert_equal(295, ShuttleSearch.minutes_to_wait('./test/shuttle_search_test.txt'))
  end

  def test_first_puzzle
    assert_equal(2845, ShuttleSearch.minutes_to_wait)
  end

  def test_something
    assert_equal(754018, ShuttleSearch.find(%w[67 7 59 61]))
    assert_equal(779210, ShuttleSearch.find(%w[67 x 7 59 61]))
    assert_equal(1068781, ShuttleSearch.find(%w[7 13 x x 59 x 31 19]))
  end

  def test_second_puzzle
    # raw_busses = File.readlines('./lib/shuttle_search.txt')[1].split(',')
    assert_equal(325, ShuttleSearch.find(%w[13 x x 41]))
    assert_equal(92168, ShuttleSearch.find(%w[328 x x x x x x x x x 569]))
    assert_equal(92168, ShuttleSearch.find(%w[13 x x 41 x x x x x x x x x 569]))
  end
end
