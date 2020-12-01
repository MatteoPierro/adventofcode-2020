# frozen_string_literal: true

module ReportRepair
  class << self
    def file_lines(path)
      File.open(path).each_line.map(&:chop)
    end

    def fix(expense_report: nil, size: 2)
      expense_report ||= file_lines('./lib/expense_report.txt')
      expense_report
        .map(&:to_i)
        .combination(size)
        .find { |combination| combination.sum == 2020 }
        .reduce(:*)
    end
  end
end
