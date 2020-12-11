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
    # skip # Quite slow, enable it only when needed
    assert_equal(2299, SeatingSystem.count_stabilized_empty_seat('./lib/seating_system.txt'))
  end

  def test_x
    skip
    layout = ["L.......#....",
              ".L.L.#.#.#.#.",
              ".............",
              '..#..........']

    seating_system = SeatingSystem.new(layout.map(&:chars))
    # assert_equal(layout.join("\n"), seating_system.to_s)

    row = layout[1]

    # row_index = 1
    # seat_index = 1
    # assert_equal('.', seating_system.find_neighbours_2(row, row_index, seat_index))

    row_index = 0
    seat_index = 2
    assert_equal('L', seating_system.find_neighbour([1,1],row, row_index, seat_index))
    assert_equal('L', seating_system.find_neighbour([-1,1],row, row_index, seat_index))
    assert_equal('#', seating_system.find_neighbour([0,1],row, row_index, seat_index))
    assert_equal('L', seating_system.find_neighbour([-1,0],row, row_index, seat_index))
    assert_equal('#', seating_system.find_neighbour([1,0],row, row_index, seat_index))

    row_index = 3
    seat_index = 8
    assert_equal('#', seating_system.find_neighbour([0,-1],row, row_index, seat_index))

    row_index = 3
    seat_index = 9
    assert_equal('#', seating_system.find_neighbour([-1,-1],row, row_index, seat_index))

    row_index = 3
    seat_index = 3
    assert_equal('#', seating_system.find_neighbour([1,-1],row, row_index, seat_index))
  end

  def test_count_occupied_seats_extended
    seating_system = SeatingSystem.from_file(
      './test/seating_system_test.txt',
      occupied_neighbours: 5,
      neighbours_finder: SeatingSystem::EXTENDED_NEIGHBOUR_FINDER
    )
    initial_layout = File.read('./test/seating_system_test.txt')[0..-2]
    assert_equal(initial_layout, seating_system.to_s)

    seating_system.stabilize
    assert_equal(26, seating_system.count_occupied_seats)
  end

  def test_second_puzzle
    # skip # Quite slow, enable it only when needed
    assert_equal(2047, SeatingSystem.count_stabilized_empty_seat(
      './lib/seating_system.txt',
      occupied_neighbours: 5,
      neighbours_finder: SeatingSystem::EXTENDED_NEIGHBOUR_FINDER
      ))
  end
end
