# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/15

class RambunctiousRecitation
  def self.number_2020th(initial_sequence)
    rambunctious_recitation = RambunctiousRecitation.new(initial_sequence)

    (1...2020).each { |_| rambunctious_recitation.number }

    rambunctious_recitation.number
  end

  attr_reader :initial_sequence, :last_number, :lru, :turn

  def initialize(initial_sequence)
    @initial_sequence = initial_sequence
    @last_number = nil
    @lru = {}
    @turn = 0
  end

  def number
    @turn += 1
    @last_number = next_number
    @lru[@last_number] = [] if @lru[@last_number].nil?
    @lru[@last_number] << turn
    @last_number
  end

  private

  def next_number
    return initial_sequence.shift unless initial_sequence.empty?

    last_number_history = @lru[last_number]

    if last_number_history.nil? || last_number_history.length == 1
      0
    else
      last_number_history[-1] - last_number_history[-2]
    end
  end
end
