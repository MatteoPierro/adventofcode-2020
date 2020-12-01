# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/first_day'

class FirstDayTest < Minitest::Test
  def test_parses_line_files
    path = './test/test_file'
    assert_equal %w[1721 979 366 299 675 1456], FirstDay.file_lines(path).to_a
  end

  def test_permutations
    assert_equal([[1, 2], [1, 3], [2, 3]], FirstDay.combinations(array: [1, 2, 3], size: 2).to_a)
  end
end
