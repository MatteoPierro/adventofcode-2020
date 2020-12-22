# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_helper'

class CrabCombatTest < Minitest::Test
  def test_first_puzzle
    crab_combat = CrabCombat.from_file('./lib/crab_combat.txt')

    crab_combat.play_game

    assert_equal(33_421, crab_combat.winning_player_score)
  end

  def test_recursion_ends
    first_player_cards = [43, 19]
    second_player_cards = [2, 29, 14]
    recursive_crab_combat = RecursiveCrabCombat.new(first_player_cards, second_player_cards)
    winner = recursive_crab_combat.play_game
    assert_equal(:first_player, winner)
  end

  def test_second_puzzle
    skip # a bit slow ~2 seconds
    recursive_crab_combat = RecursiveCrabCombat.from_file('./lib/crab_combat.txt')

    recursive_crab_combat.play_game

    assert_equal(33_651, recursive_crab_combat.winning_player_score)
  end

  class RecursiveCrabCombat
    class << self
      def from_file(file_path)
        blocks = File.read_blocks(file_path)
        first_player_cards = blocks[0][1..].map(&:to_i).to_a
        second_player_cards = blocks[1][1..].map(&:to_i).to_a
        new(first_player_cards, second_player_cards)
      end
    end

    attr_reader :first_player_cards, :second_player_cards, :previous_first_player_hands

    def initialize(first_player_cards, second_player_cards)
      @first_player_cards = first_player_cards
      @second_player_cards = second_player_cards
      @previous_first_player_hands = Set.new
    end

    def play_round
      first_player_card = first_player_cards.shift
      second_player_card = second_player_cards.shift

      if first_player_cards.length >= first_player_card && second_player_cards.length >= second_player_card
        play_recursive_game(first_player_card, second_player_card)
      elsif first_player_card > second_player_card
        first_player_cards.push(first_player_card, second_player_card)
      else
        second_player_cards.push(second_player_card, first_player_card)
      end
    end

    def play_game
      loop do
        return :second_player if first_player_cards.empty?
        return :first_player if second_player_cards.empty?

        first_player_cards_set = Set.new(first_player_cards)
        return :first_player if previous_first_player_hands.include?(first_player_cards_set)

        previous_first_player_hands << first_player_cards_set

        play_round
      end
    end

    def winning_player_score
      winning = first_player_cards.empty? ? second_player_cards : first_player_cards
      winning.reverse.map.with_index { |value, index| value * (index + 1) }.sum
    end

    private

    def play_recursive_game(first_player_card, second_player_card)
      recursive_game = RecursiveCrabCombat.new(
        first_player_cards[0...first_player_card],
        second_player_cards[0...second_player_card]
      )
      if recursive_game.play_game == :first_player
        first_player_cards.push(first_player_card, second_player_card)
      else
        second_player_cards.push(second_player_card, first_player_card)
      end
    end
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
