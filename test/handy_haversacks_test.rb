# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/handy_haversacks'

class HandyHaversacksTest < Minitest::Test
  def test_find_shiny_gold_containers
    rules = {
      'bring white' => ['light red', 'dark orange'],
      'muted yellow' => ['light red', 'dark orange'],
      'shiny gold' => ['bring white', 'muted yellow']
    }

    assert_equal ['bring white', 'muted yellow', 'light red', 'dark orange'].sort,
                 HandyHaversacks.find_shiny_gold_containers(rules).sort
  end

  def test_first_example_find_shiny_gold_containers
    rules = HandyHaversacks.read_containers('./test/handy_haversacks_test.txt')
    assert_equal 4, HandyHaversacks.find_shiny_gold_containers(rules).count
  end

  def test_first_puzzle
    rules = HandyHaversacks.read_containers('./lib/handy_haversacks.txt')
    assert_equal 226, HandyHaversacks.find_shiny_gold_containers(rules).count
  end

  def test_find_bags_in_shiny_gold
    rules = {
      'shiny gold' => [{ n: 2, bag: 'dark red' }],
      'dark red' => [{ n: 2, bag: 'dark orange' }],
      'dark orange' => [{ n: 2, bag: 'dark yellow' }],
      'dark yellow' => [{ n: 2, bag: 'dark green' }],
      'dark green' => [{ n: 2, bag: 'dark blue' }],
      'dark blue' => [{ n: 2, bag: 'dark violet' }],
      'dark violet' => []
    }

    assert_equal 126, HandyHaversacks.find_bags_in_shiny_gold(rules)
  end

  def test_second_example_find_bags_in_shiny_gold
    rules = HandyHaversacks.read_content('./test/handy_haversacks_test.txt')
    assert_equal 32, HandyHaversacks.find_bags_in_shiny_gold(rules)
  end

  def test_second_puzzle
    rules = HandyHaversacks.read_content('./lib/handy_haversacks.txt')
    assert_equal 9569, HandyHaversacks.find_bags_in_shiny_gold(rules)
  end
end
