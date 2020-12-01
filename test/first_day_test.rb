# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/first_day'

class FirstDayTest < Minitest::Test
  def test_something
    assert_equal 'jip', FirstDay.foo
  end
end
