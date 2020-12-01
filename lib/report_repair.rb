# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/1

module ReportRepair
  class << self
    def fix(expense_report: nil, size: 2)
      expense_report ||= File.readlines('./lib/expense_report.txt')
      expense_report
        .map(&:to_i)
        .combination(size)
        .find { |combination| combination.sum == 2020 }
        .reduce(:*)
    end
  end
end
