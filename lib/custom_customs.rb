# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/6

module CustomCustoms
  class << self
    def sum_groups_positive_answers(file_path = nil)
      file_path ||= './lib/custom_customs.txt'
      groups_answers = File.read_blocks(file_path)
      groups_answers.map(&method(:count_group_positive_answers)).sum
    end

    def count_group_positive_answers(group_answers)
      group_answers.map(&:chars).flatten.to_set.count
    end
  end
end
