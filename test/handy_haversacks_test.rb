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
    contents_to_containers = HandyHaversacks.read_containers('./test/handy_haversacks_test.txt')
    assert_equal 4, HandyHaversacks.find_shiny_gold_containers(contents_to_containers).count
  end

  def test_first_puzzle
    contents_to_containers = HandyHaversacks.read_containers('./lib/handy_haversacks.txt')
    assert_equal 226, HandyHaversacks.find_shiny_gold_containers(contents_to_containers).count
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

    assert_equal 126, HandyHaversacks.find_bags(containers_to_contents)
  end

  def test_second_example_find_bags_in_shiny_gold
    containers_to_contents = HandyHaversacks.read_content('./test/handy_haversacks_test.txt')
    assert_equal 32, HandyHaversacks.find_bags(containers_to_contents)
  end

  def test_second_puzzle
    containers_to_contents = HandyHaversacks.read_content('./lib/handy_haversacks.txt')
    assert_equal 9569, HandyHaversacks.find_bags(containers_to_contents)
  end
end
