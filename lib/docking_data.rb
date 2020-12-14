# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/14

class DockingData
  attr_reader :mask, :memory

  def initialize
    @memory = {}
  end

  def execute_instruction(instruction)
    mask_match = /^mask = (?<mask>.*)$/.match(instruction)
    return execute_mask_change(mask_match[:mask]) unless mask_match.nil?

    match_mem = /^mem\[(?<address>\d+)\] = (?<value>\d+)$/.match(instruction)
    execute_change_value(match_mem[:address].to_i, match_mem[:value].to_i)
  end

  def memory_values_sum
    memory.map { |_, value| value }.sum
  end

  private

  def execute_mask_change(mask)
    @mask = mask.chars
  end

  def execute_change_value(address, value)
    binary_value = value.to_s(2)
    binary_value = '0' * (mask.length - binary_value.length) + binary_value
    binary_corrected_value = mask.map.with_index do |mask_value, index|
      if mask_value == 'X'
        binary_value[index]
      else
        mask_value
      end
    end
    @memory[address] = binary_corrected_value.join.to_i(2)
  end
end
