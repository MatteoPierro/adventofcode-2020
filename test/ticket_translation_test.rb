# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ticket_translation'

class TicketTranslationTest < Minitest::Test
  def test_first_puzzle
    ticket_translation = TicketTranslation.from_file('./lib/ticket_translation.txt')

    assert_equal(19_093, ticket_translation.sum_invalid_field_in_nearby_tickets)
  end

  def test_valid_nearby_tickets
    ticket_translation = TicketTranslation.from_file('./test/ticket_translation_test.txt')

    assert_equal([[7, 3, 47]], ticket_translation.valid_nearby_tickets)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def test_find_rules_position
    ticket_translation = TicketTranslation.from_file('./test/ticket_translation_test_2.txt')

    first = ticket_translation.possible_rules([3, 9, 18])
    second = ticket_translation.possible_rules([15, 1, 5])
    third = ticket_translation.possible_rules([5, 14, 9])
    assert_equal([%w[row seat], %w[class row seat], %w[class row seat]], first)
    assert_equal([%w[class row], %w[class row seat], %w[class row seat]], second)
    assert_equal([%w[class row seat], %w[class row], %w[class row seat]], third)

    assert_equal(['row'], first.first & second.first & third.first)
    assert_equal(%w[class row], first[1] & second[1] & third[1])
    assert_equal(%w[class row seat], first[2] & second[2] & third[2])

    assert_equal(%w[row class seat], ticket_translation.find_rules_position)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def test_second_puzzle
    ticket_translation = TicketTranslation.from_file('./lib/ticket_translation.txt')

    assert_equal(5_311_123_569_883, ticket_translation.multiply_departure_fields)
  end
end
