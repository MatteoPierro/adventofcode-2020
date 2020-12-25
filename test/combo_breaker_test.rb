# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/combo_breaker'

class ComboBreakerTest < Minitest::Test
  def test_find_loop_size
    assert_equal(8, ComboBreaker.find_loop_size(5_764_801))
    assert_equal(11, ComboBreaker.find_loop_size(17_807_724))
  end

  def test_find_encryption_key
    assert_equal(14_897_079, ComboBreaker.find_encryption_key(5_764_801, 11))
    assert_equal(14_897_079, ComboBreaker.find_encryption_key(17_807_724, 8))
  end

  def test_first_puzzle
    door_public_key = 2_959_251
    door_loop_size = ComboBreaker.find_loop_size(door_public_key)
    assert_equal(7_731_677, door_loop_size)
    card_public_key = 4_542_595
    assert_equal(3_803_729, ComboBreaker.find_encryption_key(card_public_key, door_loop_size))
  end
end
