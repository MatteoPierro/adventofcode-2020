# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/handheld_halting'
require_relative '../lib/assembly/instructions'
require_relative '../lib/assembly/instructions_parser'

class HandheldHaltingTest < Minitest::Test
  # rubocop:disable Metrics/MethodLength
  def test_accumulator_before_loop
    instructions = [
      Assembly::Instructions::Nop.new(0),
      Assembly::Instructions::Acc.new(1),
      Assembly::Instructions::Jmp.new(+4),
      Assembly::Instructions::Acc.new(3),
      Assembly::Instructions::Jmp.new(-3),
      Assembly::Instructions::Acc.new(99),
      Assembly::Instructions::Acc.new(1),
      Assembly::Instructions::Jmp.new(-4),
      Assembly::Instructions::Acc.new(+6)
    ]

    assert_equal(5, HandheldHalting.accumulator_before_loop(instructions))
  end
  # rubocop:enable Metrics/MethodLength

  def test_parse_instruction
    instruction = Assembly::Instructions::Parser.parse_instruction('nop +0')
    assert_kind_of(Assembly::Instructions::Nop, instruction)
    assert_equal(0, instruction.value)

    instruction = Assembly::Instructions::Parser.parse_instruction('acc +1')
    assert_kind_of(Assembly::Instructions::Acc, instruction)
    assert_equal(1, instruction.value)

    instruction = Assembly::Instructions::Parser.parse_instruction('jmp -3')
    assert_kind_of(Assembly::Instructions::Jmp, instruction)
    assert_equal(-3, instruction.value)
  end

  def test_first_puzzle
    raw_instructions = File.readlines('./lib/handheld_halting.txt')
    instructions = Assembly::Instructions::Parser.parse_instructions(raw_instructions)
    assert_equal(1528, HandheldHalting.accumulator_before_loop(instructions))
  end

  # rubocop:disable Metrics/MethodLength
  def test_fix_program
    instructions = [
      Assembly::Instructions::Nop.new(0),
      Assembly::Instructions::Acc.new(1),
      Assembly::Instructions::Jmp.new(+4),
      Assembly::Instructions::Acc.new(3),
      Assembly::Instructions::Jmp.new(-3),
      Assembly::Instructions::Acc.new(99),
      Assembly::Instructions::Acc.new(1),
      Assembly::Instructions::Jmp.new(-4),
      Assembly::Instructions::Acc.new(+6)
    ]

    assert_equal(8, HandheldHalting.fix_program(instructions))
  end
  # rubocop:enable Metrics/MethodLength

  def test_second_puzzle
    raw_instructions = File.readlines('./lib/handheld_halting.txt')
    instructions = Assembly::Instructions::Parser.parse_instructions(raw_instructions)
    assert_equal(640, HandheldHalting.fix_program(instructions))
  end
end
