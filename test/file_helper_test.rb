# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_helper'

class FileHelperTest < Minitest::Test
  def test_parses_line_files
    path = './test/test_file'
    assert_equal %w[1721 979 366 299 675 1456], File.readlines(path).to_a
  end
end
