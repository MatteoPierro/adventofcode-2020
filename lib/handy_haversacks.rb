# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/7

class HandyHaversacks

  def self.read(file_path)
    File.readlines(file_path).each_with_object({}) do |line, rules|
      line_match = line.match(/^(?<bag>.+) bags contain (?<contents>.*)./)
      container = line_match[:bag]
      contents = line_match[:contents].split(', ')
      contents.each do |content|
        content_match = content.match(/^(?<size>\d+) (?<color>.*) bag/)
        color = content_match.nil? ? 'none' : content_match[:color]
        containers = rules[color] || []
        containers << container
        rules[color] = containers
      end
    end
  end

  def self.find_shiny_gold_containers(rules)
    new(rules).find_shiny_gold_containers
  end

  attr_reader :rules

  def initialize(rules)
    @rules = rules
  end

  def find_shiny_gold_containers(visited = [], to_visit = rules['shiny gold'])
    return visited if to_visit.empty?

    next_container = to_visit.pop
    return find_shiny_gold_containers(visited, to_visit) if visited.include?(next_container)

    visited << next_container
    find_shiny_gold_containers(visited, to_visit + (rules[next_container] || []))
  end
end
