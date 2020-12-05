# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/5

module BinaryBoarding
  class << self
    def max_seat_id(tickets = nil)
      tickets ||= File.readlines('./lib/binary_boarding.txt')
      tickets.map(&method(:seat_id)).max
    end

    def seat_id(ticket)
      binary_ticket = ticket.gsub(/[FL]/, '0').gsub(/[BR]/, '1')
      row = binary_ticket.slice(0, 7).to_i(2)
      column = binary_ticket.slice(7, 3).to_i(2)
      row * 8 + column
    end
  end
end
