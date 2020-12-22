# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_helper'

class CrabCombatTest < Minitest::Test
  def test_first_puzzle
    crab_combat = CrabCombat.from_file('./lib/crab_combat.txt')

    crab_combat.play_game

    assert_equal(33_421, crab_combat.winning_player_score)
  end

  class CrabCombat
    class << self
      def from_file(file_path)
        blocks = File.read_blocks(file_path)
        first_player_cards = blocks[0][1..].map(&:to_i).to_a
        second_player_cards = blocks[1][1..].map(&:to_i).to_a
        new(first_player_cards, second_player_cards)
      end
    end

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
