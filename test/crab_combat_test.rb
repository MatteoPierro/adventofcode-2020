# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_helper'

class CrabCombatTest < Minitest::Test

  def test_winning_player_score
    crab_combat = CrabCombat.new([9, 2, 6, 3, 1], [5, 8, 4, 7, 10])

    crab_combat.play_round

    assert_equal([2, 6, 3, 1, 9, 5], crab_combat.first_player_cards)
    assert_equal([8, 4, 7, 10], crab_combat.second_player_cards)

    crab_combat.play_round

    assert_equal([6, 3, 1, 9, 5], crab_combat.first_player_cards)
    assert_equal([4, 7, 10, 8, 2], crab_combat.second_player_cards)

    crab_combat.play_game

    assert_equal([], crab_combat.first_player_cards)
    assert_equal([3, 2, 10, 6, 8, 5, 9, 4, 7, 1], crab_combat.second_player_cards)
    assert_equal(306, crab_combat.winning_player_score)
  end

  class CrabCombat
    attr_reader :first_player_cards, :second_player_cards

    def initialize(first_player_cards, second_player_cards)
      @first_player_cards = first_player_cards
      @second_player_cards = second_player_cards
    end

    def winning_player_score
      winning = first_player_cards.empty? ? second_player_cards : first_player_cards
      winning.reverse.map.with_index { |value, index| value * (index + 1) }.sum
    end

    def play_game
      loop do
        return if first_player_cards.empty? || second_player_cards.empty?
        play_round
      end
    end

    def play_round
      first_player_card = first_player_cards.shift
      second_player_card = second_player_cards.shift
      if first_player_card > second_player_card
        @first_player_cards += [first_player_card, second_player_card]
      else
        @second_player_cards += [second_player_card, first_player_card]
      end
    end
  end
end
