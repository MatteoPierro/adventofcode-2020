# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/password_philosophy'

class PasswordPhilosophyTest < Minitest::Test
  def test_compliant_password_to_policy
    assert PasswordPhilosophy.compliant?('1-3 a: abcde')
  end

  def test_not_compliant_password_to_policy
    assert !PasswordPhilosophy.compliant?('1-3 b: cdefg')
  end

  def test_count_compliant_password_to_policy
    passwords_with_policies = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']
    assert_equal 2, PasswordPhilosophy.count_compliant(passwords_with_policies)
  end

  def test_solution_first_puzzle
    assert_equal 620, PasswordPhilosophy.count_compliant
  end
end
