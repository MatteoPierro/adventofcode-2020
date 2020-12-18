# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/operation_order'

class OperationOrderTest < Minitest::Test
  def test_expression_with_brackets
    expression = '1 + (2 * 3) + (4 * (5 + 6))'
    expression_without_brackets = solve_brackets(expression)

    assert_equal('1 + 6 + 44', expression_without_brackets)
    solution = solve_simple_expression(expression_without_brackets)
    assert_equal(51, solution)
  end

  def test_expression_starting_with_brackets
    assert_equal(13_632, solve('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'))
  end

  def test_first_puzzle
    result = File.readlines('./lib/operation_order.txt')
                 .map(&method(:solve))
                 .sum

    assert_equal(24_650_385_570_008, result)
  end

  def solve(expression)
    solve_simple_expression(solve_brackets(expression))
  end

  def solve_simple_expression(expression)
    return expression.to_i if expression.match?(/^\d+$/)

    new_expression = expression.gsub(/^(\d+) ([+*]) (\d+)/) do |_|
      execute_operation(Regexp.last_match(2), Regexp.last_match(1), Regexp.last_match(3))
    end

    solve_simple_expression(new_expression)
  end

  def solve_brackets(expression)
    return expression unless expression.include?(')')

    solve_brackets(solve_bracket(expression))
  end

  def execute_operation(operation, first, second)
    case operation
    when '*'
      first.to_i * second.to_i
    when '+'
      first.to_i + second.to_i
    end
  end

  def solve_bracket(expression)
    expression.gsub(/\((([^()])+)\)/) { |_| solve_simple_expression(Regexp.last_match(1)) }
  end
end
