# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ticket_translation'

class TicketTranslationTest < Minitest::Test

  def test_read_notes
    notes_blocks = File.read_blocks('./lib/ticket_translation.txt')
    raw_limits = notes_blocks[0]
    nearby_tickets_values = notes_blocks[-1][1..-1]
                           .map{ |raw_ticket| raw_ticket.split(',').map(&:to_i) }
                           .flatten
                           .to_a
    ticket_limits = raw_limits
             .map { |raw_field_limits| raw_field_limits.scan(/\s(\d+)-(\d+)/) }
             .map { |fields_limits| fields_limits.map { |l| TicketTranslation::Limit.new(l.first.to_i, l.last.to_i)} }
             .flatten
             .to_a

    result = nearby_tickets_values.reject do |value|
      ticket_limits.any? do |limit|
        limit.include?(value)
      end
    end.sum

    assert_equal(19093, result)
  end
end
