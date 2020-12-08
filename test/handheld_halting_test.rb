# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/handheld_halting'

class HandheldHaltingTest < Minitest::Test
  # rubocop:disable Metrics/MethodLength
  def test_accumulator_before_loop
    instructions = [
      HandheldHalting::Nop.new(0),
      HandheldHalting::Acc.new(1),
      HandheldHalting::Jmp.new(+4),
      HandheldHalting::Acc.new(3),
      HandheldHalting::Jmp.new(-3),
      HandheldHalting::Acc.new(99),
      HandheldHalting::Acc.new(1),
      HandheldHalting::Jmp.new(-4),
      HandheldHalting::Acc.new(+6)
    ]

    assert_equal(5, HandheldHalting.accumulator_before_loop(instructions))
  end
  # rubocop:enable Metrics/MethodLength

  def test_parse_instruction
    instruction = HandheldHalting.parse_instruction('nop +0')
    assert_kind_of(HandheldHalting::Nop, instruction)
    assert_equal(0, instruction.value)

    instruction = HandheldHalting.parse_instruction('acc +1')
    assert_kind_of(HandheldHalting::Acc, instruction)
    assert_equal(1, instruction.value)

    instruction = HandheldHalting.parse_instruction('jmp -3')
    assert_kind_of(HandheldHalting::Jmp, instruction)
    assert_equal(-3, instruction.value)
  end

  def test_first_puzzle
    raw_instructions = File.readlines('./lib/handheld_halting.txt')
    instructions = HandheldHalting.parse_instructions(raw_instructions)
    assert_equal(1528, HandheldHalting.accumulator_before_loop(instructions))
  end

  # rubocop:disable Metrics/MethodLength
  def test_fix_program
    instructions = [
      HandheldHalting::Nop.new(0),
      HandheldHalting::Acc.new(1),
      HandheldHalting::Jmp.new(+4),
      HandheldHalting::Acc.new(3),
      HandheldHalting::Jmp.new(-3),
      HandheldHalting::Acc.new(99),
      HandheldHalting::Acc.new(1),
      HandheldHalting::Jmp.new(-4),
      HandheldHalting::Acc.new(+6)
    ]

    assert_equal(8, HandheldHalting.fix_program(instructions))
  end
  # rubocop:enable Metrics/MethodLength

  def test_second_puzzle
    raw_instructions = File.readlines('./lib/handheld_halting.txt')
    instructions = HandheldHalting.parse_instructions(raw_instructions)
    assert_equal(640, HandheldHalting.fix_program(instructions))
  end
end
