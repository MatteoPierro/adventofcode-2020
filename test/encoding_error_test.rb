# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/encoding_error'

class EncodingErrorTest < Minitest::Test
  def test_find_error
    sequence = [35, 20, 15, 25, 47, 40,
                62, 55, 65, 95, 102, 117,
                150, 182, 127, 219, 299,
                277, 309, 576]

    assert_equal(127, EncodingError.find_error(sequence: sequence, preamble_length: 5))
  end

  def test_first_puzzle
    sequence = File.readlines('./lib/encoding_error.txt').map(&:to_i).to_a
    assert_equal(26_134_589, EncodingError.find_error(sequence: sequence))
  end
end
