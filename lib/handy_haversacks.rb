# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/7

class HandyHaversacks
  def self.read_containers(file_path)
    File.readlines(file_path).each_with_object({}) do |line, contents_to_containers|
      line_match = line.match(/^(?<container>.+) bags contain (?<contents>.*)./)
      container = line_match[:container]
      contents = line_match[:contents].split(', ')
      contents.each do |content|
        content_match = content.match(/^(?<size>\d+) (?<content>.*) bag/)
        content = content_match.nil? ? 'none' : content_match[:content]
        containers = contents_to_containers[content] || []
        containers << container
        contents_to_containers[content] = containers
      end
    end
  end

  def self.read_content(file_path)
    File.readlines(file_path).each_with_object({}) do |line, containers_to_contents|
      line_match = line.match(/^(?<container>.+) bags contain (?<contents>.*)./)
      container = line_match[:container]
      contents = containers_to_contents[container] || []
      raw_contents = line_match[:contents].split(', ')
      raw_contents.each do |raw_content|
        content_match = raw_content.match(/^(?<size>\d+) (?<color>.*) bag/)
        break if content_match.nil?

        contents << { n: content_match[:size].to_i, bag: content_match[:color] }
      end
      containers_to_contents[container] = contents
    end
  end

  def self.find_shiny_gold_containers(contents_to_containers, visited = [], to_visit = contents_to_containers['shiny gold'])
    return visited if to_visit.empty?

    current_container = to_visit.pop
    return find_shiny_gold_containers(contents_to_containers, visited, to_visit) if visited.include?(current_container)

    visited << current_container
    find_shiny_gold_containers(contents_to_containers, visited, to_visit + (contents_to_containers[current_container] || []))
  end

  def self.find_bags(containers_to_contents, bag = 'shiny gold')
    contents = containers_to_contents[bag]
    contents.map { |content| content[:n] + content[:n] * find_bags(containers_to_contents, content[:bag]) }.sum
  end
end
