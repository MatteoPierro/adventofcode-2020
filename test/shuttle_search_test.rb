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
end
