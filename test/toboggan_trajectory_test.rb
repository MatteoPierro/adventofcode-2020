# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/toboggan_trajectory'

class TobogganTrajectoryTest < Minitest::Test
  def test_two_x_two_area
    area = %w[
      ..#
      #..
    ]
    assert_equal(1, TobogganTrajectory.new(area).count_trees)
  end

  def test_first_puzzle_solution
    assert_equal(272, TobogganTrajectory.new.count_trees)
  end

  def test_one_x_one_area_with_different_combination
    area = %w[
      .
      #
    ]
    toboggan_trajectory = TobogganTrajectory.new(area)
    assert_equal(1, toboggan_trajectory.count_trees(right: 2, down: 1))
  end

  def test_multiply_trees
    area = File.readlines('./test/toboggan_trajectory_test.txt')
    toboggan_trajectory = TobogganTrajectory.new(area)
    assert_equal(2, toboggan_trajectory.count_trees(right: 1, down: 1))
    assert_equal(7, toboggan_trajectory.count_trees(right: 3, down: 1))
    assert_equal(3, toboggan_trajectory.count_trees(right: 5, down: 1))
    assert_equal(4, toboggan_trajectory.count_trees(right: 7, down: 1))
    assert_equal(2, toboggan_trajectory.count_trees(right: 1, down: 2))
    assert_equal(336, toboggan_trajectory.multiply_trees)
  end

  def test_second_puzzle_solution
    assert_equal(3_898_725_600, TobogganTrajectory.new.multiply_trees)
  end
end
