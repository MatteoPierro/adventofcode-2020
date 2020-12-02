# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/2

class PasswordPhilosophy
  COUNT_POLICY = lambda do |min, max, letter, word|
    occurrences = word.count(letter)
    occurrences >= min && occurrences <= max
  end

  EXACTLY_ONE_POLICY = lambda do |first_position, second_position, letter, word|
    return false if word[first_position - 1] == letter && word[second_position - 1] == letter

    word[first_position - 1] == letter || word[second_position - 1] == letter
  end

  attr_reader :policy

  def initialize(policy = nil)
    @policy = policy || COUNT_POLICY
  end

  def count_compliant(password_with_constraints = nil)
    password_with_constraints ||= File.readlines('./lib/password_philosophy.txt')
    password_with_constraints.select(&method(:compliant?)).count
  end

  def compliant?(password_with_constraints)
    match = password_with_constraints.match(/^(?<first>\d+)-(?<second>\d+)\s(?<letter>\w):\s(?<word>\w+)$/)
    first = match[:first].to_i
    second = match[:second].to_i
    letter = match[:letter]
    word = match[:word]
    policy.call(first, second, letter, word)
  end
end
