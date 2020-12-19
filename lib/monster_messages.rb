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
    rules['11'] = "(#{rule_eleven_with_repetitions})"
    reduce_rule_zero
  end

  def reduce_rule(rule)
    return rule.delete(' ') unless rule.match?(/\d/)

    reduced_rule = rule.gsub(/(\d+)/) { |_| replace_rule(Regexp.last_match(1)) }
    reduce_rule(reduced_rule)
  end

  private

  def replace_rule(rule)
    new_rule = rules[rule].gsub(/^(.*) \| (.*)$/) do |_|
      "(#{Regexp.last_match(1)}|#{Regexp.last_match(2)})"
    end
    "(#{new_rule})"
  end

  MAX_REPETITIONS = 4

  def rule_eleven_with_repetitions
    (1..MAX_REPETITIONS).each.map do |rep|
      "(#{repetitions('(42)', rep)} #{repetitions('(31)', rep)})"
    end.join('|')
  end

  def repetitions(string, number)
    (0...number).each.map { |_| string }.join(' ')
  end
end
