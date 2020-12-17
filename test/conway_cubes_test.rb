# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/conway_cubes'

class ConwayCubesTest < Minitest::Test
  def test_tick
    skip # slow
    initial_active_cubes = [[1, 0, 0], [2, 1, 0], [0, 2, 0], [1, 2, 0], [2, 2, 0]]
    conway_cubes = ConwayCubes.new(initial_active_cubes)
    assert_equal(112, conway_cubes.evolve)
  end

  def test_first_puzzle
    skip # slow
    conway_cubes = ConwayCubes.from_file('./lib/conway_cubes.txt')
    assert_equal(426, conway_cubes.evolve)
  end

  def test_four_dimensions
    skip # very very slow
    initial_active_cubes = [[1, 0, 0, 0], [2, 1, 0, 0], [0, 2, 0, 0], [1, 2, 0, 0], [2, 2, 0, 0]]
    conway_cubes = ConwayCubes.new(initial_active_cubes)
    assert_equal(848, conway_cubes.evolve)
  end

  def test_second_puzzle
    skip # very very slow
    conway_cubes = ConwayCubes.from_file('./lib/conway_cubes.txt', 4)
    assert_equal(1892, conway_cubes.evolve)
  end
end
