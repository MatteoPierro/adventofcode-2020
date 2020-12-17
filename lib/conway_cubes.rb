# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/17

class ConwayCubes
  class << self
    def from_file(file_path, dimension = 3)
      lines = File.readlines(file_path)
      ConwayCubes.new(parse_lines(lines, dimension))
    end

    private

    def parse_lines(lines, dimension)
      lines.flat_map.with_index do |line, y|
        line.chars.map.with_index do |value, x|
          if value == '.'
            nil
          elsif dimension == 4
            [x, y, 0, 0]
          else
            [x, y, 0]
          end
        end
      end.compact.to_a
    end
  end

  attr_reader :active_cubes, :delta

  def initialize(active_cubes)
    @active_cubes = active_cubes.to_set
    @delta = [-1, 0, 1]
    (1...active_cubes.first.length).each do
      @delta = @delta.product([-1, 0, 1])
    end
    @delta = @delta.map(&:flatten).reject { |d| d.all?(&:zero?) }.to_a
  end

  def evolve(iterations = 6)
    (1..iterations).each { |_| tick }
    active_cubes.length
  end

  def tick
    new_active_cubes = Set.new

    active_cubes.each do |active_cube|
      neighbours = neighbours(active_cube)
      neighbours_by_status = neighbours_by_status(neighbours)
      number_of_active_neighbours = neighbours_by_status[:active].length
      new_active_cubes << active_cube if [2, 3].include?(number_of_active_neighbours)
      new_active_cubes += new_active(neighbours_by_status[:inactive])
    end

    @active_cubes = new_active_cubes
  end

  private

  def new_active(inactive_cubes)
    inactive_cubes.each.with_object(Set.new) do |inactive, new_active|
      neighbours = neighbours(inactive)
      neighbours_by_status = neighbours_by_status(neighbours)
      new_active << inactive if neighbours_by_status[:active].length == 3
    end
  end

  def neighbours(cube)
    delta.map { |ds| ds.map.with_index { |d, index| cube[index] + d } }.to_set
  end

  def active?(cube)
    active_cubes.include?(cube)
  end

  def neighbours_by_status(neighbours)
    neighbours.each.with_object({ inactive: [], active: [] }) do |neighbour, neighbours_by_status|
      if active?(neighbour)
        neighbours_by_status[:active] << neighbour
      else
        neighbours_by_status[:inactive] << neighbour
      end
    end
  end
end
