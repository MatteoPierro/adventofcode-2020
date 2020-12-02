# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/2

class PasswordPhilosophy
  def self.count_compliant(passwords_with_policies = nil)
    passwords_with_policies ||= File.readlines('./lib/password_philosophy.txt')
    passwords_with_policies.select(&method(:compliant?)).count
  end

  def self.compliant?(password_with_policy)
    match = password_with_policy.match(/^(?<min>\d+)-(?<max>\d+)\s(?<letter>\w):\s(?<word>\w+)$/)
    min = match[:min].to_i
    max = match[:max].to_i
    letter = match[:letter]
    word = match[:word]
    occurrences = word.count(letter)
    occurrences >= min && occurrences <= max
  end
end
