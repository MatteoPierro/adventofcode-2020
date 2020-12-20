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

  def test_x
    blocks = File.read_blocks('./test/jurassic_jigsaw.txt')

    tiles_by_id = blocks.each.with_object({}) do |block, acc|
      id = block[0].match(/^Tile (\d+):$/)[1].to_i
      acc[id] = Tile.new(block[1..-1])
    end

    matches_by_tile_id = find_matches(tiles_by_id)
    borders = matches_by_tile_id.select { |_, v| v.values.select(&:nil?).count == 2 }

    first_border = borders.first
    id = first_border.first
    adjacent = first_border.last
    first_tile = tiles_by_id[id]
    if adjacent[:bottom].nil?
      first_tile.flipud!
    end
    if adjacent[:right].nil?
      first_tile.fliplr!
    end

    puts "\n\n first row \n\n"
    current_border_id = id
    current_border = first_tile
    puts current_border_id
    puts first_tile.to_s

    row = build_row(current_border, current_border_id, tiles_by_id)

    row_id = 2
    loop do
      puts "\n\n building #{row_id} row \n\n"
      row_id += 1
      bottom_border = current_border.bottom_border
      puts "bottom border #{bottom_border.to_a}"
      other_tiles_by_id = tiles_by_id.reject { |i, _| i == current_border_id }
      match = find_match(bottom_border, other_tiles_by_id)
      break if match.nil?
      other_tile = tiles_by_id[match[:other_tile]]
      puts "match #{match}"
      if match[:flipped]
        if match[:other_position] == :bottom
          other_tile.rot90!(2)
        elsif match[:other_position] == :right
          other_tile.rot90!
          other_tile.fliplr!
        elsif match[:other_position] == :left
          other_tile.rot90!(-1)
        else
          other_tile.fliplr!
        end
      else
        if match[:other_position] == :bottom
          other_tile.flipud!
        elsif match[:other_position] == :right
          other_tile.rot90!
        elsif match[:other_position] == :left
          other_tile.rot90!(-1)
          other_tile.fliplr!
        end
      end

      puts match[:other_tile]
      puts other_tile.to_s
      row = build_row(other_tile, match[:other_tile], tiles_by_id)
      current_border_id = match[:other_tile]
      current_border = other_tile
    end

    assert_equal('', row)
    puts first_tile.to_s
    assert_equal(1951, id)
  end

  def find_matches(tiles_by_id)
    fit_borders = {}
    tiles_by_id.each do |id, tile|
      other_tiles_by_id = tiles_by_id.reject { |i, _| i == id }
      matches_by_position = {}
      tile.borders_by_position.each do |position, border|
        matches_by_position[position] = find_match(border, other_tiles_by_id)
      end
      fit_borders[id] = matches_by_position
    end
    fit_borders
  end

  def find_match(border, other_tiles_by_id)
    flipped_border = border.flipud
    other_tiles_by_id.each do |other_tile_id, other_tile|
      other_tile.borders_by_position.each do |other_position, other_border|
        if other_border == border
          return {
            flipped: false,
            other_tile: other_tile_id,
            other_position: other_position
          }
        elsif other_border == flipped_border
          return {
            flipped: true,
            other_tile: other_tile_id,
            other_position: other_position
          }
        end
      end
    end
    nil
  end

  def build_row(current_border, current_border_id, tiles_by_id)
    row = [current_border_id]
    loop do
      left_border = current_border.right_border
      other_tiles_by_id = tiles_by_id.reject { |i, _| i == current_border_id }
      match = find_match(left_border, other_tiles_by_id)
      break if match.nil?
      other_tile = tiles_by_id[match[:other_tile]]
      if match[:flipped]
        if match[:other_position] == :up
          other_tile.rot90!
        elsif match[:other_position] == :bottom
          other_tile.rot90!(-1)
          other_tile.flipud!
        elsif match[:other_position] == :right
          other_tile.rot90!(2)
        else
          other_tile.flipud!
        end
      else
        if match[:other_position] == :up
          other_tile.rot90!
          other_tile.flipud!
        elsif match[:other_position] == :bottom
          other_tile.rot90!(-1)
        elsif match[:other_position] == :right
          other_tile.fliplr!
        end
      end
      current_border = other_tile
      current_border_id = match[:other_tile]
      row << current_border_id
      puts match[:other_tile]
      puts other_tile.to_s
    end
    row
  end

  class Tile
    include Numo

    attr_reader :borders_by_position, :tile

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
      update_borders_by_position
    end

    def rot90!(times = 1)
      !
      @tile = @tile.rot90(times)
      update_borders_by_position
    end

    def flipud!
      @tile = @tile.flipud
      update_borders_by_position
    end

    def fliplr!
      @tile = @tile.fliplr
      update_borders_by_position
    end

    def right_border
      @tile[true, -1]
    end

    def bottom_border
      @tile[-1, true]
    end

    def borders
      [@tile[0, true], @tile[-1, true], @tile[true, 0], @tile[true, -1]]
    end

    def to_s
      @tile.to_a.map do |row|
        row.to_a.map do |pixel|
          if pixel == 0
            '.'
          else
            "#"
          end
        end.join
      end.join("\n")
    end

    private

    def update_borders_by_position
      @borders_by_position = {
        up: @tile[0, true],
        left: @tile[true, 0],
        bottom: @tile[-1, true],
        right: @tile[true, -1]
      }
    end
  end
end
