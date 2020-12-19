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

  def test_second_puzzle
    # blocks = File.read_blocks('./test/monster_messages_2.txt')
    blocks = File.read_blocks('./lib/monster_messages.txt')
    rules_block = blocks.first
    parsed_rules = parse_rules(rules_block)
    parsed_rules['8'] = '((42)+)'
    parsed_rules['11']  = '(?<forty_two>((42)+))(?<thirty_one>((31)+))'
    rule_zero = parsed_rules['0']
    reduce_rule = reduce_rule(rule_zero, parsed_rules)
    messages = blocks.last

    reduced_42 = reduce_rule(parsed_rules['42'], parsed_rules)
    reduced_31 = reduce_rule(parsed_rules['31'], parsed_rules)
    # assert_equal('', 'baabbaaaabbaaaababbaababb'.scan(/#{reduced_42}/).count)

    number_of_matched_rules = messages.select do |message|
      match = message.match(/^#{reduce_rule}$/)

      if match.nil?
        false
      else
        # if match[:forty_two].match?(reduced_42)
        #   p "matched 42 for #{match[:forty_two]}"
        # end
        #
        # if match[:thirty_one].match?(reduced_31)
        #   p "matched 31 for #{match[:thirty_one]}"
        # end
        # p "#{match[:forty_two]} #{match[:thirty_one]}"
        # p "\n"
        forty_two_size = match[:forty_two].scan(/^#{reduced_42}$/).size
        thirty_one_size = match[:thirty_one].scan(/^#{reduced_31}$/).size
        if forty_two_size != thirty_one_size
          p "message #{message}"
          p "42 match #{match[:forty_two]} size #{forty_two_size}"
          p "31 match #{match[:thirty_one]} size #{thirty_one_size}"
          p "\n"
        end

        forty_two_size <= thirty_one_size
      end
    end
    # result = %w[bbabbbbaabaabba
    # babbbbaabbbbbabbbbbbaabaaabaaa
    # aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    # bbbbbbbaaaabbbbaaabbabaaa
    # bbbababbbbaaaaaaaabbababaaababaabab
    # ababaaaaaabaaab
    # ababaaaaabbbaba
    # baabbaaaabbaaaababbaababb
    # abbbbabbbbaaaababbbbbbaaaababb
    # aaaaabbaabaaaaababaa
    # aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    # aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba]
    assert_equal(296, number_of_matched_rules.count)
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
        "(#{$1}|#{$2})"
      end
      "(#{n_rule})"
    end
    reduce_rule(s, other_rules)
  end
end
