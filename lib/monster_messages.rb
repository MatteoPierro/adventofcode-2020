# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/19

class MonsterMessages
  class << self
    def from_file(file_path)
      blocks = File.read_blocks(file_path)
      messages = blocks.last
      rules_block = blocks.first
      new(parse_rules(rules_block), messages)
    end

    RULES_PATTERN = /^(?<id>\d+): (?<rule>.*)$/.freeze

    def parse_rules(rules_block)
      rules_block.each_with_object({}) do |rule_block, rules|
        match = rule_block.match(RULES_PATTERN)
        rules[match[:id]] = match[:rule].delete('"')
      end
    end
  end

  attr_reader :rules, :messages, :rule_zero

  def initialize(rules, messages)
    @rules = rules
    @messages = messages
  end

  def reduce_rule_zero
    @rule_zero = reduce_rule(rules['0'])
  end

  def count_valid_messages
    messages.select { |message| message.match?(/^#{rule_zero}$/) }.count
  end

  def introduce_loops
    rules['8'] = '((42)+)'
    rules['11'] = '(?<forty_two>((42)+))(?<thirty_one>((31)+))'
    reduce_rule_zero
  end

  def count_valid_messages_with_loops
    reduced_42 = reduce_rule(rules['42'])
    reduced_31 = reduce_rule(rules['31'])
    valid_messages = messages.select do |message|
      match = message.match(/^#{rule_zero}$/)

      if match.nil?
        false
      else
        forty_two_size = match[:forty_two].scan(/^#{reduced_42}$/).size
        thirty_one_size = match[:thirty_one].scan(/^#{reduced_31}$/).size
        # if forty_two_size != thirty_one_size
        #   p "message #{message}"
        #   p "42 match #{match[:forty_two]} size #{forty_two_size}"
        #   p "31 match #{match[:thirty_one]} size #{thirty_one_size}"
        #   p "\n"
        # end

        forty_two_size <= thirty_one_size
      end
    end

    valid_messages.count
  end

  def reduce_rule(rule)
    return rule.delete(' ') unless rule.match?(/\d/)

    reduced_rule = rule.gsub(/(\d+)/) do |_|
      sub_rule = rules[Regexp.last_match(1)]
      new_rule = sub_rule.gsub(/^(.*) \| (.*)$/) do |_|
        "(#{Regexp.last_match(1)}|#{Regexp.last_match(2)})"
      end
      "(#{new_rule})"
    end
    reduce_rule(reduced_rule)
  end
end
