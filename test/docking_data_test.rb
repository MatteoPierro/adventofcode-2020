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
end
