# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shuttle_search'

class ShuttleSearchTest < Minitest::Test
  def test_find_departure
    time = 939
    buses = ShuttleSearch.busses_from('7,13,59,31,19')
    departure = ShuttleSearch.find_departure(time, buses)
    assert_equal(ShuttleSearch::Departure.new(59, 944), departure)
  end

  def test_minutes_to_wait
    assert_equal(295, ShuttleSearch.minutes_to_wait('./test/shuttle_search_test.txt'))
  end

  def test_first_puzzle
    assert_equal(2845, ShuttleSearch.minutes_to_wait)
  end

  def test_find_consecutive_time
    assert_equal(754_018, ShuttleSearch.find_consecutive_time('67,7,59,61'))
    assert_equal(779_210, ShuttleSearch.find_consecutive_time('67,x,7,59,61'))
    assert_equal(779_210, ShuttleSearch.find_consecutive_time('67,x,7,59,61'))
    assert_equal(1_068_781, ShuttleSearch.find_consecutive_time('7,13,x,x,59,x,31,19'))
  end

  def test_second_puzzle
    raw_busses = File.readlines('./lib/shuttle_search.txt')[1]
    assert_equal(487_905_974_205_117, ShuttleSearch.find_consecutive_time(raw_busses))
  end
end
