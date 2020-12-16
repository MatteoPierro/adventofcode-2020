# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/16

class TicketTranslation
  class << self
    def from_file(file_path)
      notes_blocks = File.read_blocks(file_path)
      ticket_limits = parse_ticket_limits(notes_blocks[0])
      nearby_tickets = parse_nearby_tickets(notes_blocks[-1][1..])
      new(nearby_tickets: nearby_tickets, ticket_limits: ticket_limits)
    end

    private

    def parse_ticket_limits(raw_limits)
      ticket_limits = {}
      raw_limits.each do |row_limit|
        limit_name, limits = parse_field_limits(row_limit)
        ticket_limits[limit_name] = limits
      end
      ticket_limits
    end

    def parse_field_limits(row_limit)
      limit_name = row_limit.match(/^(.*):/)[1]
      limits = row_limit.scan(/\s(\d+)-(\d+)/)
                        .map { |l| TicketTranslation::Limit.new(l.first.to_i, l.last.to_i) }
                        .to_a
      [limit_name, limits]
    end

    def parse_nearby_tickets(raw_nearby_tickets)
      raw_nearby_tickets
        .map { |raw_ticket| raw_ticket.split(',').map(&:to_i) }
        .to_a
    end
  end

  attr_reader :ticket_limits, :nearby_tickets

  def initialize(nearby_tickets:, ticket_limits:)
    @ticket_limits = ticket_limits
    @nearby_tickets = nearby_tickets
  end

  def sum_invalid_field_in_nearby_tickets
    nearby_tickets.flatten.reject(&method(:any_limit_match?)).sum
  end

  Limit = Struct.new(:min_value, :max_value) do
    def include?(value)
      value >= min_value && value <= max_value
    end
  end

  private

  def any_limit_match?(value)
    ticket_limits.any? do |_, field_limits|
      field_limits.any? { |limit| limit.include?(value) }
    end
  end
end
