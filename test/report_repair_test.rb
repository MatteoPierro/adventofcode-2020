# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/report_repair'

class ReportRepairTest < Minitest::Test
  def test_parses_line_files
    path = './test/test_file'
    assert_equal %w[1721 979 366 299 675 1456], ReportRepair.file_lines(path).to_a
  end

  def test_fix
    expense_report = %w[1721 979 366 299 675 1456]
    assert_equal(514_579, ReportRepair.fix(expense_report))
  end

  def test_first_solution
    assert_equal(806_656, ReportRepair.fix)
  end
end
