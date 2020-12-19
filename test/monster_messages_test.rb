# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/monster_messages'

class MonsterMessagesTest < Minitest::Test
  def test_first_puzzle
    monster_messages = MonsterMessages.from_file('./lib/monster_messages.txt')
    monster_messages.reduce_rule_zero

    assert_equal(192, monster_messages.count_valid_messages)
  end

  def test_second_puzzle
    monster_messages = MonsterMessages.from_file('./lib/monster_messages.txt')
    monster_messages.introduce_loops

    assert_equal(296, monster_messages.count_valid_messages_with_loops)
  end
end
