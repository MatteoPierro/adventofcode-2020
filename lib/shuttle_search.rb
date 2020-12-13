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

  def self.find(raw_busses)
    busses =
      raw_busses.reverse
        .map.with_index
        .reject { |s, _| s == 'x' }
        .map { |s, p| [s.to_i, p] }
        .to_a

    pace = busses.first.first
    maximum = busses.map { |b| b.first }.reduce(&:*)

    loop do
      break if busses.all? { |bus_id, position| (maximum - position) % bus_id == 0}
      maximum -= pace
    end
    maximum - busses.last.last
  end

  Departure = Struct.new(:bus, :time)
end
