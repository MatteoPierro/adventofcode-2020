# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/23

class CrabCups
  attr_reader :max_value, :cups_by_value
  attr_accessor :current_cup

  def initialize(configuration, max_value = nil)
    @max_value = max_value.nil? ? configuration.length : max_value
    @cups_by_value = {}
    first_cup = Cup.new(configuration[0])
    @cups_by_value[configuration[0]] = first_cup
    current_cup = first_cup
    configuration[1..].each do |value|
      next_cup = Cup.new(value)
      current_cup.next = next_cup
      @cups_by_value[value] = next_cup
      current_cup = next_cup
    end
    current_cup.next = first_cup
    @current_cup = first_cup
  end

  def configuration(start_value = nil)
    start_cup = start_value.nil? ? current_cup : cups_by_value[start_value]
    configuration = []
    current = start_cup
    while current.next != start_cup
      configuration << current.value
      current = current.next
    end
    configuration << current.value
    configuration
  end

  def play(iterations = 100)
    (1..iterations).each { |_| tick }
  end

  def tick
    pickup = find_pickup
    current_cup.next = pickup.last.next
    next_cup_value = current_cup.value - 1
    pickup_value = pickup.map(&:value)
    destination_cup = find_destination_cup(next_cup_value, pickup_value)
    tail_pickup = destination_cup.next
    destination_cup.next = pickup.first
    pickup.last.next = tail_pickup
    @current_cup = current_cup.next
  end

  private

  def find_destination_cup(next_cup_value, pickup_value)
    return find_destination_cup(next_cup_value - 1, pickup_value) if pickup_value.include?(next_cup_value)
    return find_destination_cup(max_value, pickup_value) if next_cup_value.zero?

    cups_by_value[next_cup_value]
  end

  def find_pickup
    first = current_cup.next
    second = first.next
    third = second.next
    [first, second, third]
  end

  class Cup
    attr_reader :value
    attr_accessor :next

    def initialize(value)
      @value = value
    end
  end
end
