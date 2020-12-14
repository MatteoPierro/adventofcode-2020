# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/docking_data'

class DockingDataTest < Minitest::Test
  def test_execute_instruction
    docking_data = DockingData.new
    docking_data.execute_instruction('mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
    docking_data.execute_instruction('mem[8] = 11')
    docking_data.execute_instruction('mem[7] = 101')
    docking_data.execute_instruction('mem[8] = 0')
    assert_equal(64, docking_data.memory[8])
    assert_equal(165, docking_data.memory_values_sum)
  end

  def test_first_puzzle
    docking_data = DockingData.new
    instructions = File.readlines('./lib/docking_data.txt')
    instructions.each { |instruction| docking_data.execute_instruction(instruction) }
    assert_equal(12_135_523_360_904, docking_data.memory_values_sum)
  end

  def test_execute_instruction_with_memory_address_decoder
    docking_data = DockingData.new(DockingData::MemoryAddressDecoder.new)
    docking_data.execute_instruction('mask = 000000000000000000000000000000X1001X')
    docking_data.execute_instruction('mem[42] = 100')
    docking_data.execute_instruction('mask = 00000000000000000000000000000000X0XX')
    docking_data.execute_instruction('mem[26] = 1')
    assert_equal(208, docking_data.memory_values_sum)
  end

  def test_second_puzzle
    docking_data = DockingData.new(DockingData::MemoryAddressDecoder.new)
    instructions = File.readlines('./lib/docking_data.txt')
    instructions.each { |instruction| docking_data.execute_instruction(instruction) }
    assert_equal(2_741_969_047_858, docking_data.memory_values_sum)
  end
end
