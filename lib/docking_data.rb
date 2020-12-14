# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/14

class DockingData
  attr_reader :memory

  def initialize(decoder = Decoder.new)
    @memory = {}
    @decoder = decoder
  end

  def execute_instruction(instruction)
    mask_match = /^mask = (?<mask>.*)$/.match(instruction)
    return @decoder.mask = mask_match[:mask] unless mask_match.nil?

    match_mem = /^mem\[(?<address>\d+)\] = (?<value>\d+)$/.match(instruction)
    @decoder.execute_change_value(memory, match_mem[:address].to_i, match_mem[:value].to_i)
  end

  def memory_values_sum
    memory.map { |_, value| value }.sum
  end

  class Decoder
    attr_reader :mask

    def mask=(mask)
      @mask = mask.chars
    end

    def execute_change_value(memory, address, value)
      binary_value = padded_binary(value)
      binary_corrected_value = correct_value(binary_value)
      memory[address] = binary_corrected_value.join.to_i(2)
    end

    def correct_value(binary_value)
      mask.map.with_index do |mask_value, index|
        if mask_value == 'X'
          binary_value[index]
        else
          mask_value
        end
      end
    end

    def padded_binary(value)
      binary_value = value.to_s(2)
      '0' * (mask.length - binary_value.length) + binary_value
    end
  end

  class MemoryAddressDecoder < Decoder
    def execute_change_value(memory, address, value)
      padded_address = padded_binary(address)
      floating_address = floating_address(padded_address)
      addresses_for(floating_address).each { |a| memory[a] = value }
    end

    private

    def addresses_for(floating_address)
      floating_bits_product(floating_address)
        .map { |bits| address_for(bits, floating_address) }
    end

    def address_for(bits, floating_address)
      address = floating_address.join
      bits.each { |bit| address.sub!('X', bit.to_s) }
      address.to_i(2)
    end

    def floating_bits_product(floating_address)
      return [] if floating_address.count('X').zero?

      acc = [0, 1]

      (1...floating_address.count('X')).each do |_|
        acc = acc.product([0, 1])
      end

      acc.map(&:flatten)
    end

    def floating_address(address)
      mask.map.with_index do |mask_value, index|
        if mask_value == '0'
          address[index]
        else
          mask_value
        end
      end
    end
  end
end
