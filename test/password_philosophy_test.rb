# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/password_philosophy'

class PasswordPhilosophyTest < Minitest::Test
  def test_compliant_password_to_policy
    assert PasswordPhilosophy.new.compliant?('1-3 a: abcde')
  end

  def test_not_compliant_password_to_policy
    assert !PasswordPhilosophy.new.compliant?('1-3 b: cdefg')
  end

  def test_count_compliant_password_to_policy
    password_with_constraints = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']
    assert_equal 2, PasswordPhilosophy.new.count_compliant(password_with_constraints)
  end

  def test_solution_first_puzzle
    assert_equal 620, PasswordPhilosophy.new.count_compliant
  end

  def test_not_compliant_password_to_exactly_one_policy
    policy = PasswordPhilosophy::EXACTLY_ONE_POLICY
    assert !PasswordPhilosophy.new(policy).compliant?('2-9 c: ccccccccc')
  end

  def test_solution_second_puzzle
    policy = PasswordPhilosophy::EXACTLY_ONE_POLICY
    assert_equal 727, PasswordPhilosophy.new(policy).count_compliant
  end
end
