# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/11

class SeatingSystem
  def self.count_stabilized_empty_seat(file_path,
                                       occupied_neighbours: 4,
                                       neighbours_finder: ADJACENT_NEIGHBOUR_FINDER)
    seating_system = from_file(file_path, occupied_neighbours: occupied_neighbours, neighbours_finder: neighbours_finder)
    seating_system.stabilize
    seating_system.count_occupied_seats
  end

  def self.from_file(file_path,
                     occupied_neighbours: 4,
                     neighbours_finder: ADJACENT_NEIGHBOUR_FINDER)
    initial_layout = File.readlines(file_path)
    new(initial_layout.map(&:chars),
        occupied_neighbours:occupied_neighbours,
        neighbours_finder: neighbours_finder)
  end

  attr_accessor :layout, :occupied_neighbours, :neighbours_finder

  def initialize(
    layout,
    occupied_neighbours: 4,
    neighbours_finder: ADJACENT_NEIGHBOUR_FINDER)
    @layout = layout
    @occupied_neighbours = occupied_neighbours
    @neighbours_finder = neighbours_finder
  end

  def count_occupied_seats
    to_s.count('#')
  end

  def stabilize
    old_layout = to_s
    loop do
      tick
      break if old_layout == to_s

      old_layout = to_s
    end
  end

  def tick
    @layout = layout
              .map
              .with_index { |row, row_index| tick_row(row, row_index) }
  end

  def to_s
    layout.map(&:join).join("\n")
  end

  private

  def tick_row(row, row_index)
    row.map.with_index do |value, seat_index|
      tick_seat(row, row_index, seat_index, value)
    end
  end

  def tick_seat(row, row_index, seat_index, value)
    return value if value == '.'

    neighbours = neighbours_finder.call(layout, row, row_index, seat_index)
                                          .filter { |seat| seat == '#' }

    return '#' if value == 'L' && neighbours.count.zero?
    return 'L' if value == '#' && neighbours.count >= occupied_neighbours

    value
  end

  WINDOW = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]
  ].freeze

  # rubocop:disable Metrics/AbcSize
  ADJACENT_NEIGHBOUR_FINDER = -> (layout, row, row_index, seat_index) do
    invalid_position = lambda do |position|
      position.any?(&:negative?) ||
        position.first >= row.length ||
        position.last >= layout.length
    end

    WINDOW
      .map { |dx, dy| [dx + seat_index, dy + row_index] }
      .reject { |position| invalid_position.call(position) }
      .map { |x, y| layout[y][x] }
  end

  EXTENDED_NEIGHBOUR_FINDER = -> (layout, row, row_index, seat_index) do
    find_neighbour = -> (layout, increment, row, row_index, seat_index) do
      loop do
        seat_index += increment.first
        row_index += increment.last
        return '.' if seat_index < 0 || seat_index >= row.length
        return '.' if row_index < 0 || row_index >= layout.length

        current_position = layout[row_index][seat_index]
        return current_position if current_position == '#' || current_position == 'L'
      end
    end

    WINDOW
      .map { |increment| find_neighbour.call(layout, increment, row, row_index, seat_index) }
  end
  # rubocop:enable Metrics/AbcSize
end
