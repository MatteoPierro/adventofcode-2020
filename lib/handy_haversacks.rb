# frozen_string_literal: true

require_relative 'file_helper'
require 'set'

# Solution for https://adventofcode.com/2020/day/7

class HandyHaversacks
  class << self
    def read_bag(file_path)
      File.readlines(file_path).each_with_object(Bags.new) do |line, bag|
        line_match = line.match(/^(?<container>.+) bags contain (?<contents>.*)./)
        container = line_match[:container]
        contents = line_match[:contents].split(', ')
        contents.each do |raw_content|
          bag.add(container: container, raw_content: raw_content)
        end
      end
    end

    def find_shiny_gold_containers(
      contents_to_containers,
      visited = [],
      to_visit = contents_to_containers['shiny gold']
    )
      return visited if to_visit.empty?

      current_container = to_visit.pop
      if visited.include?(current_container)
        return find_shiny_gold_containers(contents_to_containers, visited, to_visit)
      end

      visited << current_container
      current_content_containers = contents_to_containers[current_container] || []
      find_shiny_gold_containers(contents_to_containers, visited, to_visit + current_content_containers)
    end

    def count_bags_in_a_shiny_gold_bag(containers_to_contents, bag = 'shiny gold')
      contents = containers_to_contents[bag]
      contents
        .map do |content|
          content[:n] + content[:n] * count_bags_in_a_shiny_gold_bag(containers_to_contents, content[:bag])
        end
        .sum
    end
  end

  class Bags
    attr_reader :containers_to_contents, :contents_to_containers

    def initialize
      @contents_to_containers = {}
      @containers_to_contents = {}
    end

    def add(container:, raw_content:)
      content_match = raw_content.match(/^(?<size>\d+) (?<content>.*) bag/)
      add_to_contents_to_containers(container, content_match)
      add_to_to_containers_contents(container, content_match)
    end

    private

    def add_to_contents_to_containers(container, content_match)
      content = content_match.nil? ? 'none' : content_match[:content]
      content_containers = contents_to_containers[content] || []
      content_containers << container
      contents_to_containers[content] = content_containers
    end

    def add_to_to_containers_contents(container, content_match)
      container_contents = containers_to_contents[container] || []
      container_contents << { n: content_match[:size].to_i, bag: content_match[:content] } unless content_match.nil?
      containers_to_contents[container] = container_contents
    end
  end
end
