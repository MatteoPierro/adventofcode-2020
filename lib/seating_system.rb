# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/11

class SeatingSystem
  def self.count_stabilized_empty_seat(file_path,
                                       occupied_neighbours: 4,
                                       neighbours_finder: ADJACENT_NEIGHBOUR_FINDER)
    seating_system = from_file(file_path,
                               occupied_neighbours: occupied_neighbours,
                               neighbours_finder: neighbours_finder)
    seating_system.stabilize
    seating_system.count_occupied_seats
  end

  def self.from_file(file_path,
                     occupied_neighbours: 4,
                     neighbours_finder: ADJACENT_NEIGHBOUR_FINDER)
    initial_layout = File.readlines(file_path)
    new(initial_layout.map(&:chars),
        occupied_neighbours: occupied_neighbours,
        neighbours_finder: neighbours_finder)
  end

  attr_accessor :layout, :occupied_neighbours, :neighbours_finder

  def initialize(
    layout,
    occupied_neighbours: 4,
    neighbours_finder: ADJACENT_NEIGHBOUR_FINDER
  )
    @layout = layout
    @occupied_neighbours = occupied_neighbours
    @neighbours_finder = neighbours_finder
  end

  def count_occupied_seats
    layout.map { |row| row.count('#') }.sum
  end

  def stabilize
    old_layout = layout
    loop do
      tick
      break if old_layout == layout

      old_layout = layout
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

  ADJACENT_NEIGHBOUR_FINDER = lambda do |layout, row, row_index, seat_index|
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

  EXTENDED_NEIGHBOUR_FINDER = lambda do |layout, row, row_index, seat_index|
    find_neighbour = lambda do |increment|
      current_seat = seat_index
      current_row = row_index
      loop do
        current_seat += increment.first
        current_row += increment.last
        return '.' if current_seat.negative? || current_seat >= row.length
        return '.' if current_row.negative? || current_row >= layout.length

        current_position = layout[current_row][current_seat]
        return current_position if %w[# L].include?(current_position)
      end
    end

    WINDOW.map { |increment| find_neighbour.call(increment) }
  end
end
