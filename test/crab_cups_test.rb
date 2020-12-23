# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/crab_cups'

class CrabCupsTest < Minitest::Test
  def test_first_puzzle
    configuration = [3, 1, 5, 6, 7, 9, 8, 2, 4]
    crab_cups = CrabCups.new(configuration)

    crab_cups.play

    assert_equal('72496583', crab_cups.configuration(1)[1..].join)
  end

  def test_second_puzzle
    skip # slow ~13 seconds
    configuration = [3, 1, 5, 6, 7, 9, 8, 2, 4]
    ((configuration.max + 1)..1_000_000).each { |value| configuration << value }
    crab_cups = CrabCups.new(configuration)

    crab_cups.play(10_000_000)

    next_one_value = crab_cups.cups_by_value[1].next.value
    next_next_one_value = crab_cups.cups_by_value[1].next.next.value
    assert_equal(41_785_843_847, next_one_value * next_next_one_value)
  end
end
