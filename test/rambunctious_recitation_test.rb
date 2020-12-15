# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/rambunctious_recitation'

class RambunctiousRecitationTest < Minitest::Test
  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def test_number
    initial_sequence = [0, 3, 6]
    rambunctious_recitation = RambunctiousRecitation.new(initial_sequence)
    ### Turn 1
    assert_equal(0, rambunctious_recitation.number)
    assert_equal(1, rambunctious_recitation.turn)
    assert_equal([3, 6], rambunctious_recitation.initial_sequence)
    assert_equal({ 0 => [1] }, rambunctious_recitation.lru)

    ### Turn 2
    assert_equal(3, rambunctious_recitation.number)
    assert_equal(2, rambunctious_recitation.turn)
    assert_equal([6], rambunctious_recitation.initial_sequence)
    assert_equal({ 0 => [1], 3 => [2] }, rambunctious_recitation.lru)

    ### Turn 3
    assert_equal(6, rambunctious_recitation.number)
    assert_equal(3, rambunctious_recitation.turn)
    assert_equal([], rambunctious_recitation.initial_sequence)
    assert_equal({ 0 => [1], 3 => [2], 6 => [3] }, rambunctious_recitation.lru)

    ### Turn 4
    assert_equal(0, rambunctious_recitation.number)
    assert_equal(4, rambunctious_recitation.turn)
    assert_equal([], rambunctious_recitation.initial_sequence)
    assert_equal({ 0 => [1, 4], 3 => [2], 6 => [3] }, rambunctious_recitation.lru)

    ### Turn 5
    assert_equal(3, rambunctious_recitation.number)
    assert_equal(5, rambunctious_recitation.turn)
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize

  def test_number_2020th
    assert_equal(436, RambunctiousRecitation.number_at_iteration([0, 3, 6]))
    assert_equal(1, RambunctiousRecitation.number_at_iteration([1, 3, 2]))
    assert_equal(10, RambunctiousRecitation.number_at_iteration([2, 1, 3]))
    assert_equal(27, RambunctiousRecitation.number_at_iteration([1, 2, 3]))
    assert_equal(78, RambunctiousRecitation.number_at_iteration([2, 3, 1]))
    assert_equal(438, RambunctiousRecitation.number_at_iteration([3, 2, 1]))
    assert_equal(1836, RambunctiousRecitation.number_at_iteration([3, 1, 2]))
  end

  def test_first_puzzle
    assert_equal(852, RambunctiousRecitation.number_at_iteration([0, 3, 1, 6, 7, 5]))
  end

  def test_second_puzzle
    skip # Really really slow test
    assert_equal(6_007_666, RambunctiousRecitation.number_at_iteration(
                              [0, 3, 1, 6, 7, 5],
                              30_000_000
                            ))
  end
end
