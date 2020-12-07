# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/handy_haversacks'

class HandyHaversacksTest < Minitest::Test
  def test_find_shiny_gold_containers
    contents_to_containers = {
      'bring white' => ['light red', 'dark orange'],
      'muted yellow' => ['light red', 'dark orange'],
      'shiny gold' => ['bring white', 'muted yellow']
    }

    assert_equal ['bring white', 'muted yellow', 'light red', 'dark orange'].sort,
                 HandyHaversacks.find_shiny_gold_containers(contents_to_containers).sort
  end

  def test_first_example_find_shiny_gold_containers
    bag = HandyHaversacks.read_bag('./test/handy_haversacks_test.txt')
    assert_equal 4, HandyHaversacks.count_shiny_gold_containers(bag.contents_to_containers)
  end

  def test_first_puzzle
    bag = HandyHaversacks.read_bag('./lib/handy_haversacks.txt')
    assert_equal 226, HandyHaversacks.count_shiny_gold_containers(bag.contents_to_containers)
  end

  def test_find_bags_in_shiny_gold
    containers_to_contents = {
      'shiny gold' => [{ n: 2, bag: 'dark red' }],
      'dark red' => [{ n: 2, bag: 'dark orange' }],
      'dark orange' => [{ n: 2, bag: 'dark yellow' }],
      'dark yellow' => [{ n: 2, bag: 'dark green' }],
      'dark green' => [{ n: 2, bag: 'dark blue' }],
      'dark blue' => [{ n: 2, bag: 'dark violet' }],
      'dark violet' => []
    }

    assert_equal 126, HandyHaversacks.count_bags_in_a_shiny_gold_bag(containers_to_contents)
  end

  def test_second_example_find_bags_in_shiny_gold
    bag = HandyHaversacks.read_bag('./test/handy_haversacks_test.txt')
    puts bag.containers_to_contents
    assert_equal 32, HandyHaversacks.count_bags_in_a_shiny_gold_bag(bag.containers_to_contents)
  end

  def test_second_puzzle
    bag = HandyHaversacks.read_bag('./lib/handy_haversacks.txt')
    assert_equal 9569, HandyHaversacks.count_bags_in_a_shiny_gold_bag(bag.containers_to_contents)
  end
end
