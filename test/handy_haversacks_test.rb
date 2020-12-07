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

  def test_parse_input
    rules = HandyHaversacks.read('./test/handy_haversacks_test.txt')
    assert_equal 4, HandyHaversacks.find_shiny_gold_containers(rules).count
  end

  def test_first_puzzle
    rules = HandyHaversacks.read('./lib/handy_haversacks.txt')
    assert_equal 4, HandyHaversacks.find_shiny_gold_containers(rules).count
  end

end
