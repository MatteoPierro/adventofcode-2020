# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/toboggan_trajectory'

class TobogganTrajectoryTest < Minitest::Test
  def test_two_x_two_area
    area = %w[
      ..#
      #..
    ]
    assert_equal(1, TobogganTrajectory.count_trees(area))
  end

  def test_first_puzzle_solution
    assert_equal(272, TobogganTrajectory.count_trees)
  end
end
