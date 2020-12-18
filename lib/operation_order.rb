# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/18

class OperationOrder
  def self.solve_expressions(expressions_path)
    operation_order = OperationOrder.new

    File.readlines(expressions_path)
        .map { |expression| operation_order.solve(expression) }
        .sum
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
