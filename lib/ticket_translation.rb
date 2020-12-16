# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/16

class TicketTranslation

  Limit = Struct.new(:min, :max) do
    def include?(value)
      value >= min && value <= max
    end
  end
end
