# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ticket_translation'

class TicketTranslationTest < Minitest::Test
  def test_first_puzzle
    ticket_translation = TicketTranslation.from_file('./lib/ticket_translation.txt')

    assert_equal(19_093, ticket_translation.sum_invalid_field_in_nearby_tickets)
  end
end
