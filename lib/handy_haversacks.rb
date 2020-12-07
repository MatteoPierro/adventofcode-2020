# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/7

class HandyHaversacks
  def self.read_containers(file_path)
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

  def self.read_content(file_path)
    File.readlines(file_path).each_with_object({}) do |line, rules|
      line_match = line.match(/^(?<bag>.+) bags contain (?<contents>.*)./)
      container = line_match[:bag]
      contents = rules[container] || []
      raw_contents = line_match[:contents].split(', ')
      raw_contents.each do |raw_content|
        content_match = raw_content.match(/^(?<size>\d+) (?<color>.*) bag/)
        break if content_match.nil?

        contents << { n: content_match[:size].to_i, bag: content_match[:color] }
      end
      rules[container] = contents
    end
  end

  def self.find_shiny_gold_containers(rules)
    new(rules).find_shiny_gold_containers
  end

  def self.find_bags_in_shiny_gold(rules)
    contents = rules['shiny gold']
    contents.map { |content| content[:n] + content[:n] * find_bags(rules, content[:bag]) }.sum
  end

  def self.find_bags(rules, bag)
    contents = rules[bag]
    contents.map { |content| content[:n] + content[:n] * find_bags(rules, content[:bag]) }.sum
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
