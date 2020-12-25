# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/25

module ComboBreaker
  class << self
    SEED = 20_201_227

    def find_loop_size(key, subject_number = 7)
      loop_size = 0
      value = 1
      until value == key
        value *= subject_number
        value %= SEED
        loop_size += 1
      end
      loop_size
    end

    def find_encryption_key(key, loop_size)
      encryption_key = 1
      (1..loop_size).each do |_|
        encryption_key *= key
        encryption_key %= SEED
      end
      encryption_key
    end
  end
end
