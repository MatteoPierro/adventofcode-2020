# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/18

class OperationOrder
  def self.solve_expressions(expressions_path, math = Math.new)
    operation_order = OperationOrder.new(math)

    File.readlines(expressions_path)
        .map { |expression| operation_order.solve(expression) }
        .sum
  end

  attr_reader :math

  def initialize(math = Math.new)
    @math = math
  end

  def solve(expression)
    math.solve_simple_expression(solve_brackets(expression))
  end

  def solve_brackets(expression)
    return expression unless expression.include?(')')

    solve_brackets(solve_bracket(expression))
  end

  def solve_bracket(expression)
    expression.gsub(/\((([^()])+)\)/) do |_|
      math.solve_simple_expression(Regexp.last_match(1))
    end
  end

  class Math
    def solve_simple_expression(expression)
      return expression.to_i if expression.match?(/^\d+$/)

      new_expression = expression.gsub(/^(\d+) ([+*]) (\d+)/) do |_|
        execute_operation(Regexp.last_match(2), Regexp.last_match(1), Regexp.last_match(3))
      end

      solve_simple_expression(new_expression)
    end

    protected

    def execute_operation(operation, first, second)
      case operation
      when '*'
        first.to_i * second.to_i
      when '+'
        first.to_i + second.to_i
      end
    end
  end

  class AdvancedMath < Math
    def solve_simple_expression(expression)
      execute_multiplications(execute_sums(expression)).to_i
    end

    def execute_sums(expression)
      execute_operations(expression, '+')
    end

    def execute_multiplications(expression)
      execute_operations(expression, '*')
    end

    private

    def execute_operations(expression, operation)
      return expression unless expression.include?(operation)

      operation_regexp = /(\d+) (#{Regexp.quote(operation)}) (\d+)/
      new_expression = expression.gsub(operation_regexp) do |_|
        execute_operation(Regexp.last_match(2), Regexp.last_match(1), Regexp.last_match(3))
      end

      execute_operations(new_expression, operation)
    end
  end
end
