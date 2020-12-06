# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/6

module CustomCustoms
  class << self
    def sum_shared_positive_answers(file_path = nil)
      sum_by_criterium(file_path: file_path, criterium: :count_group_shared_positive_answers)
    end

    def sum_groups_positive_answers(file_path = nil)
      sum_by_criterium(file_path: file_path, criterium: :count_group_positive_answers)
    end

    def count_group_positive_answers(group_answers)
      group_answers.map(&:chars).flatten.to_set.count
    end

    def count_group_shared_positive_answers(group_answers)
      group_answers.map(&:chars).reduce(:&).count
    end

    private

    def sum_by_criterium(criterium:, file_path: nil)
      file_path ||= './lib/custom_customs.txt'
      groups_answers = File.read_blocks(file_path)
      groups_answers.map(&method(criterium)).sum
    end
  end
end
