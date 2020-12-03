# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/1

module TobogganTrajectory
  class << self
    def count_trees(area = nil)
      area ||= File.readlines('./lib/toboggan_trajectory.txt')
      area.each.map.with_index do |row, index|
        position = (index * 3) % row.length
        row[position]
      end.count('#')
    end
  end
end
