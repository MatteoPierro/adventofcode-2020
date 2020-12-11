# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/seating_system'

class SeatingSystemTest < Minitest::Test
  def test_count_occupied_seats
    seating_system = SeatingSystem.from_file('./test/seating_system_test.txt')
    initial_layout = File.read('./test/seating_system_test.txt')[0..-2]
    assert_equal(initial_layout, seating_system.to_s)

    seating_system.stabilize
    assert_equal(37, seating_system.count_occupied_seats)
  end

  def test_first_puzzle
    skip # Quite slow, enable it only when needed
    assert_equal(2299, SeatingSystem.count_stabilized_empty_seat('./lib/seating_system.txt'))
  end
end
