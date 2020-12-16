# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/16

class TicketTranslation
  class << self
    def from_file(file_path)
      notes_blocks = File.read_blocks(file_path)
      ticket_limits = parse_ticket_limits(notes_blocks[0])
      ticket = parse_ticket(notes_blocks[1][1])
      nearby_tickets = parse_nearby_tickets(notes_blocks[-1][1..])
      new(nearby_tickets: nearby_tickets, ticket_limits: ticket_limits, ticket: ticket)
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
        .map(&method(:parse_ticket))
        .to_a
    end

    def parse_ticket(raw_ticket)
      raw_ticket.split(',').map(&:to_i)
    end
  end

  attr_reader :ticket_limits, :nearby_tickets, :ticket

  def initialize(nearby_tickets:, ticket_limits:, ticket:)
    @ticket_limits = ticket_limits
    @nearby_tickets = nearby_tickets
    @ticket = ticket
  end

  def sum_invalid_field_in_nearby_tickets
    nearby_tickets.flatten.reject(&method(:any_limit_match?)).sum
  end

  def multiply_departure_fields
    find_rules_position.each.with_index
                       .select { |name, _| name.start_with?('departure') }
                       .map { |_, index| ticket[index] }
                       .reduce(:*)
  end

  def valid_nearby_tickets
    nearby_tickets.filter do |nearby_ticket|
      nearby_ticket.all? { |value| any_limit_match?(value) }
    end
  end

  def find_rules_position
    rules = initial_guessing

    until rules.all? { |rule| rule.length == 1 }
      found_rules = rules.select { |rule| rule.length == 1 }.flatten.to_a
      rules.each.with_index do |rule, index|
        next if rule.length == 1

        rules[index] = rule - found_rules
      end
    end

    rules.flatten
  end

  def possible_rules(valid_ticket)
    valid_ticket.map(&method(:value_rules))
  end

  def value_rules(value)
    ticket_limits
      .select { |_, limits| limits.any? { |l| l.include?(value) } }
      .map { |name, _| name }
      .to_a
  end

  Limit = Struct.new(:min_value, :max_value) do
    def include?(value)
      value >= min_value && value <= max_value
    end
  end

  private

  def initial_guessing
    rules = possible_tickets_rules.first

    possible_tickets_rules.each do |possible_rules|
      possible_rules.each_with_index do |possible_rule, index|
        rules[index] &= possible_rule
      end
    end

    rules
  end

  def possible_tickets_rules
    valid_nearby_tickets
      .map { |ticket| possible_rules(ticket) }
      .to_a
  end

  def any_limit_match?(value)
    ticket_limits.any? do |_, field_limits|
      field_limits.any? { |limit| limit.include?(value) }
    end
  end
end
