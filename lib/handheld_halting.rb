# frozen_string_literal: true

require_relative 'file_helper'
require_relative './assembly/machine'

# Solution for https://adventofcode.com/2020/day/8

module HandheldHalting
  class << self
    def fix_program(instructions)
      instructions.each.with_index do |instruction, index|
        next unless instruction.swappable?

        instructions[index] = instruction.swap
        state = Assembly::Machine.execute(instructions)
        return state.accumulator unless state.loop_detected?

        instructions[index] = instruction
      end

      raise 'Expected to find at least one instruction combination without loop'
    end

    def accumulator_before_loop(instructions)
      Assembly::Machine.execute(instructions).accumulator
    end
  end
end
