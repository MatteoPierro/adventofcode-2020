# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/11

class SeatingSystem
  def self.count_stabilized_empty_seat(file_path)
    seating_system = from_file(file_path)
    seating_system.stabilize
    seating_system.count_occupied_seats
  end

  def self.from_file(file_path)
    initial_layout = File.readlines(file_path)
    new(initial_layout.map(&:chars))
  end

  attr_accessor :layout

  def initialize(layout)
    @layout = layout
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

  WINDOW = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]
  ].freeze

  private

  def tick_row(row, row_index)
    row.map.with_index do |value, seat_index|
      tick_seat(row, row_index, seat_index, value)
    end
  end

  def tick_seat(row, row_index, seat_index, value)
    return value if value == '.'

    neighbours = find_neighbours(row, row_index, seat_index)
                 .filter { |seat| seat == '#' }

    return '#' if value == 'L' && neighbours.count.zero?
    return 'L' if value == '#' && neighbours.count >= 4

    value
  end

  # rubocop:disable Metrics/AbcSize
  def find_neighbours(row, row_index, seat_index)
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
  # rubocop:enable Metrics/AbcSize
end
