# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/monster_messages'

class MonsterMessagesTest < Minitest::Test
  def test_x
    rule = '4 1 5'
    other_rules = {
      '1' => '2 3 | 3 2',
      '2' => '4 4 | 5 5',
      '3' => '4 5 | 5 4',
      '4' => 'a',
      '5' => 'b'
    }

    reduce_rule = reduce_rule(rule, other_rules)

    assert_equal(true, 'ababbb'.match?(reduce_rule))
    assert_equal(true, 'abbbab'.match?(reduce_rule))
    assert_equal(false, 'bababa'.match?(reduce_rule))
    assert_equal(false, 'aaabbb'.match?(reduce_rule))
    assert_equal(false, 'aaaabbb'.match?(/^#{reduce_rule}$/))
  end


  def test_first_puzzle
    blocks = File.read_blocks('./lib/monster_messages.txt')
    rules_block = blocks.first
    parses_rules = parse_rules(rules_block)
    rule_zero = parses_rules['0']
    reduce_rule = reduce_rule(rule_zero, parses_rules)
    messages = blocks.last
    number_of_matched_rules = messages.select { |message| message.match?(/^#{reduce_rule}$/) }.count
    assert_equal(192, number_of_matched_rules)
  end

  def parse_rules(rules_block)
    rules_block.each_with_object({}) do |rule_block, rules|
      match = rule_block.match(/^(?<id>\d+): (?<rule>.*)$/)
      rules[match[:id]] = match[:rule].delete('"')
    end
  end

  def reduce_rule(rule, other_rules)
    return rule.delete(' ') unless rule.match?(/\d/)

    s = rule.gsub(/(\d+)/) do |_|
      sub_rule = other_rules[$1]
      n_rule = sub_rule.gsub(/^(.*) \| (.*)$/) do |_|
        "(#{$1})|(#{$2})"
      end
      "(#{n_rule})"
    end
    reduce_rule(s, other_rules)
  end
end
