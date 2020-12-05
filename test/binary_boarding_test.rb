# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/binary_boarding'

class BinaryBoardingTest < Minitest::Test
  def test_calculate_seat_id
    ticket = 'BFFFBBFRRR'
    assert_equal(567, BinaryBoarding.seat_id(ticket))
  end

  def test_max_seat_id
    tickets = %w[BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL]
    assert_equal(820, BinaryBoarding.max_seat_id(tickets))
  end

  def test_first_puzzle
    assert_equal(922, BinaryBoarding.max_seat_id)
  end
end
