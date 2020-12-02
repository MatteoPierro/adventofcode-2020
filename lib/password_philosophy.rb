# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/2

class PasswordPhilosophy
  COUNT_POLICY = lambda do |min, max, letter, word|
    occurrences = word.count(letter)
    occurrences >= min && occurrences <= max
  end

  EXACTLY_ONE_POLICY = lambda do |first_position, second_position, letter, word|
    (word[first_position - 1] == letter) ^ (word[second_position - 1] == letter)
  end

  attr_reader :policy

  def initialize(policy = nil)
    @policy = policy || COUNT_POLICY
  end

  def count_compliant(passwords_with_constraints = nil)
    passwords_with_constraints ||= File.readlines('./lib/password_philosophy.txt')
    passwords_with_constraints.select(&method(:compliant?)).count
  end

  PASSWORD_WITH_CONSTRAINTS_PATTERN = /^(?<first>\d+)-(?<second>\d+)\s(?<letter>\w):\s(?<word>\w+)$/.freeze

  def compliant?(password_with_constraints)
    match = password_with_constraints.match(PASSWORD_WITH_CONSTRAINTS_PATTERN)
    first = match[:first].to_i
    second = match[:second].to_i
    letter = match[:letter]
    word = match[:word]
    policy.call(first, second, letter, word)
  end
end
