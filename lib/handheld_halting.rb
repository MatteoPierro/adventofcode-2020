# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/8

module HandheldHalting
  class << self
    def accumulator_before_loop(instructions)
      state = MachineState.new
      Machine.new(state).execute(instructions)
      state.accumulator
    end

    def parse_instructions(raw_instructions)
      raw_instructions.map(&method(:parse_instruction))
    end

    # rubocop:disable Metrics/MethodLength
    def parse_instruction(raw_instruction)
      match = raw_instruction.match(/^(?<name>.*) (?<value>.*)$/)
      name = match[:name]
      value = match[:value].to_i
      case name
      when 'nop'
        Nop.new(value)
      when 'acc'
        Acc.new(value)
      when 'jmp'
        Jmp.new(value)
      else
        raise "Unexpected instruction #{name} with value #{value}"
      end
    end
    # rubocop:enable Metrics/MethodLength
  end

  class Machine
    def initialize(state)
      @state = state
    end

    def execute(instructions)
      used_instructions = []
      instruction_index = 0
      loop do
        instruction = instructions[instruction_index]
        break if used_instructions.include?(instruction)

        used_instructions << instruction
        instruction_index += instruction.execute(@state)
        break if instruction_index > instructions.length
      end
    end
  end

  class MachineState
    attr_accessor :accumulator

    def initialize
      @accumulator = 0
    end
  end

  module Instruction
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def execute(state)
      apply(state)
      next_instruction
    end

    def apply(_state); end

    def next_instruction
      1
    end
  end

  class Nop
    include Instruction
  end

  class Jmp
    include Instruction

    def next_instruction
      @value
    end
  end

  class Acc
    include Instruction

    def apply(state)
      state.accumulator += @value
    end
  end
end
