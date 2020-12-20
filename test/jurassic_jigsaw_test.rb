# frozen_string_literal: true

require 'minitest/autorun'
require 'numo/narray'
require_relative '../lib/file_helper'

class JurassicJigsawTest < Minitest::Test

  def test_first_puzzle
    blocks = File.read_blocks('./lib/jurassic_jigsaw.txt')

    tiles_by_id = blocks.each.with_object({}) do |block, acc|
      id = block[0].match(/^Tile (\d+):$/)[1].to_i
      acc[id] = Tile.new(block[1..-1])
    end

    borders = tiles_by_id.select do |id, tile|
      tile.borders.select do |border|
        tiles_by_id.reject { |i, _| i == id }.any? do |_, t|
          t.borders.include?(border) || t.borders.include?(border.flipud)
        end
      end.count == 2
    end

    assert_equal(13224049461431, borders.keys.reduce(&:*))
  end

  class Tile
    include Numo

    def initialize(raw_tile)
      @tile = Int32[*raw_tile.map do |row|
        row.chars.map do |pixel|
          if pixel == '.'
            0
          else
            1
          end
        end
      end]
    end

    def borders
      [@tile[0, true], @tile[-1, true], @tile[true, 0], @tile[true, -1]]
    end
  end
end
