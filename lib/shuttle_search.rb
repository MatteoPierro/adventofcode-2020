# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/13

class ShuttleSearch
  def self.minutes_to_wait(file_path = './lib/shuttle_search.txt')
    lines = File.readlines(file_path)
    time = lines[0].to_i
    busses = busses_from(lines[1])
    departure = find_departure(time, busses)
    departure.bus * (departure.time - time)
  end

  def self.find_departure(time, busses)
    busses
      .map { |bus| Departure.new(bus.number, time + bus.number - time % bus.number) }
      .min { |b1, b2| b1.time <=> b2.time }
  end

  def self.find_consecutive_time(raw_busses)
    busses = busses_from(raw_busses)
    pace = 1
    current_time = 0

    busses.each do |current_bus|
      current_time += pace until current_bus.correct_position?(current_time)

      pace *= current_bus.number
    end

    current_time
  end

  Departure = Struct.new(:bus, :time)
  Bus = Struct.new(:number, :position) do
    def correct_position?(current_time)
      ((current_time + position) % number).zero?
    end
  end

  def self.busses_from(raw_busses)
    raw_busses
      .split(',')
      .map.with_index
      .reject { |s, _| s == 'x' }
      .map { |number, position| Bus.new(number.to_i, position) }
      .to_a
  end
end
