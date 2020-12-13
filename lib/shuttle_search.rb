# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/13

class ShuttleSearch
  def self.minutes_to_wait(file_path = './lib/shuttle_search.txt')
    lines = File.readlines(file_path)
    time = lines[0].to_i
    busses = lines[1].split(',').reject { |s| s == 'x' }.map(&:to_i)
    departure = find_departure(time, busses)
    departure.bus * (departure.time - time)
  end

  def self.find_departure(time, busses)
    busses
      .map { |bus| Departure.new(bus, time + bus - time % bus) }
      .min { |b1, b2| b1.time <=> b2.time }
  end

  def self.find_consecutive_time(raw_busses)
    busses = busses_sorted_by_number(raw_busses)
    maximum_time = busses.map(&:number).reduce(&:*)
    (highest, *remaining) = busses
    pace = highest.number
    current_time = maximum_time - highest.position

    remaining.each do |current_bus|
      current_time -= pace until current_bus.correct_position?(current_time)

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

  def self.busses_sorted_by_number(raw_busses)
    raw_busses
      .map.with_index
      .reject { |s, _| s == 'x' }
      .map { |number, position| Bus.new(number.to_i, position) }
      .sort { |b1, b2| b2.number <=> b1.number }
      .to_a
  end
end
