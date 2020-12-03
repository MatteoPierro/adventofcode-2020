# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/1

class TobogganTrajectory
  attr_reader :area

  def initialize(area = nil)
    @area = area || File.readlines('./lib/toboggan_trajectory.txt')
  end

  def multiply_trees
    [
      { right: 1, down: 1 },
      { right: 3, down: 1 },
      { right: 5, down: 1 },
      { right: 7, down: 1 },
      { right: 1, down: 2 }
    ].map { |slope| count_trees(**slope) }.reduce(:*)
  end

  def count_trees(right: 3, down: 1)
    (0...area.length)
      .step(down)
      .map { |index| area[index] }
      .map.with_index { |row, index| row[(index * right) % row.length] }
      .count('#')
  end
end
