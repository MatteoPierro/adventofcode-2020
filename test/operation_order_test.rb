# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/operation_order'

class OperationOrderTest < Minitest::Test
  def test_expression_with_brackets
    operation_order = OperationOrder.new

    expression = '1 + (2 * 3) + (4 * (5 + 6))'
    expression_without_brackets = operation_order.solve_brackets(expression)
    assert_equal('1 + 6 + 44', expression_without_brackets)
    solution = operation_order.solve_simple_expression(expression_without_brackets)
    assert_equal(51, solution)
  end

  def test_expression_starting_with_brackets
    operation_order = OperationOrder.new
    expression = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
    assert_equal(13_632, operation_order.solve(expression))
  end

  def test_first_puzzle
    assert_equal(24_650_385_570_008, OperationOrder.solve_expressions('./lib/operation_order.txt'))
  end
end
