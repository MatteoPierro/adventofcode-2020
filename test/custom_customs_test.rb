# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/custom_customs'

class CustomCustomsTest < Minitest::Test
  def test_count_group_positive_answers
    group_answers = %w[ab ac]
    assert_equal 3, CustomCustoms.count_group_positive_answers(group_answers)
  end

  def test_sum_groups_positive_answers
    file_path = './test/custom_customs_test.txt'
    assert_equal 11, CustomCustoms.sum_groups_positive_answers(file_path)
  end

  def test_first_puzzle_solution
    assert_equal 6542, CustomCustoms.sum_groups_positive_answers
  end

  def test_count_group_shared_positive_answers
    group_answers = %w[ab ac]
    assert_equal 1, CustomCustoms.count_group_shared_positive_answers(group_answers)
  end

  def test_second_puzzle_solution
    assert_equal 3299, CustomCustoms.sum_shared_positive_answers
  end
end
