# frozen_string_literal: true

require 'minitest/autorun'
require 'numo/narray'
require_relative '../lib/file_helper'

class JurassicJigsawTest < Minitest::Test
  def test_first_puzzle
    blocks = File.read_blocks('./lib/jurassic_jigsaw.txt')

    tiles_by_id = tiles_by_id(blocks)

    borders = tiles_by_id.select do |_, tile|
      tile.borders.select do |border|
        other_tiles_by_id(tile, tiles_by_id).any? do |_, t|
          t.borders.include?(border) || t.borders.include?(border.flipud)
        end
      end.count == 2
    end

    assert_equal(13_224_049_461_431, borders.keys.reduce(&:*))
  end

  def test_second_puzzle
    blocks = File.read_blocks('./lib/jurassic_jigsaw.txt')
    picture = build_picture(blocks)
    number_of_monochrome_pixels = picture.to_a.join.count('1')

    picture = picture.flipud.rot90(-1)
    number_of_monsters = find_number_of_monsters(picture)

    assert_equal(2231, number_of_monochrome_pixels - RELATIVE_MONSTER_COORDINATES.length * number_of_monsters)
  end

  def build_picture(blocks)
    tiles_by_id = tiles_by_id(blocks)

    current_tile = tile_top_left(tiles_by_id)
    rows = [align_row_by_right_border(current_tile, tiles_by_id), *align_remaining_rows(current_tile, tiles_by_id)]

    Numo::NArray.concatenate(
      rows.map { |row| join_row(row, tiles_by_id) }.to_a
    )
  end

  RELATIVE_MONSTER_COORDINATES = [[0, 18],
                                  [1, 0], [1, 5], [1, 6], [1, 11], [1, 12], [1, 17], [1, 18], [1, 19],
                                  [2, 1], [2, 4], [2, 7], [2, 10], [2, 13], [2, 16]].freeze

  def find_number_of_monsters(picture)
    number_of_monsters = 0
    number_of_rows = picture.to_a.count
    number_of_columns = picture[0, true].to_a.count
    (0...(number_of_rows - 3)).each do |row_index|
      (0...(number_of_columns - 19)).each do |column_index|
        found_monster = RELATIVE_MONSTER_COORDINATES.all? do |monster_coordinate|
          r = monster_coordinate.first + row_index
          c = monster_coordinate.last + column_index
          picture[r, c] == 1
        end
        number_of_monsters += 1 if found_monster
      end
    end
    number_of_monsters
  end

  def find_matches(tiles_by_id)
    fit_borders = {}
    tiles_by_id.each do |id, tile|
      other_tiles_by_id = other_tiles_by_id(tile, tiles_by_id)
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
        if other_border == border || other_border == flipped_border
          return {
            flipped: other_border == flipped_border,
            other_tile: other_tile_id,
            other_tile_border: other_position
          }
        end
      end
    end
    nil
  end

  def align_row_by_right_border(current_tile, tiles_by_id)
    row = [current_tile.id]
    loop do
      right_border = current_tile.right_border
      match = find_match(right_border, other_tiles_by_id(current_tile, tiles_by_id))
      break if match.nil?

      current_tile = tiles_by_id[match[:other_tile]]
      align_left_border(current_tile, match)
      row << current_tile.id
    end
    row
  end

  def tile_top_left(tiles_by_id)
    border_tiles = find_matches(tiles_by_id).select { |_, v| v.values.select(&:nil?).count == 2 }
    first_border = border_tiles.first
    id = first_border.first
    first_border_tile_neighbours = first_border.last
    first_tile = tiles_by_id[id]
    first_tile.flipud! if first_border_tile_neighbours[:bottom].nil?
    first_tile.fliplr! if first_border_tile_neighbours[:right].nil?
    first_tile
  end

  def other_tiles_by_id(tile, tiles_by_id)
    tiles_by_id.reject { |i, _| i == tile.id }
  end

  def tiles_by_id(blocks)
    blocks.each.with_object({}) do |block, acc|
      id = block[0].match(/^Tile (\d+):$/)[1].to_i
      acc[id] = Tile.new(id, block[1..])
    end
  end

  def join_row(row, tiles_by_id)
    Numo::NArray.hstack(row.map do |id|
      tiles_by_id[id].tile.delete(-1, 0).delete(-1, -1).delete(0, -1).delete(0, 0)
    end.to_a)
  end

  def align_remaining_rows(current_tile, tiles_by_id)
    rows = []
    loop do
      bottom_border = current_tile.bottom_border
      match = find_match(bottom_border, other_tiles_by_id(current_tile, tiles_by_id))
      break if match.nil?

      current_tile = tiles_by_id[match[:other_tile]]
      rows << build_row(current_tile, match, tiles_by_id)
    end
    rows
  end

  def build_row(other_tile, match, tiles_by_id)
    align_up_border(other_tile, match)
    align_row_by_right_border(other_tile, tiles_by_id)
  end

  # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
  def align_up_border(tile, match)
    case match[:other_tile_border]
    when :bottom
      tile.rot90!(2) if match[:flipped]
      tile.flipud! unless match[:flipped]
    when :right
      tile.rot90!
      tile.fliplr! if match[:flipped]
    when :left
      tile.rot90!(-1)
      tile.fliplr! unless match[:flipped]
    else
      tile.fliplr! if match[:flipped]
    end
  end

  def align_left_border(tile, match)
    case match[:other_tile_border]
    when :up
      tile.rot90!
      tile.flipud! unless match[:flipped]
    when :bottom
      tile.rot90!(-1)
      tile.flipud! if match[:flipped]
    when :right
      tile.rot90!(2) if match[:flipped]
      tile.fliplr! unless match[:flipped]
    else
      tile.flipud! if match[:flipped]
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity,Metrics/MethodLength

  class Tile
    include Numo

    attr_reader :borders_by_position, :tile, :id

    def initialize(id, raw_tile)
      @id = id
      @tile = Int32[*raw_tile.map { |row| row.chars.map { |pixel| pixel == '.' ? 0 : 1 } }]
      update_borders_by_position
    end

    def rot90!(times = 1)
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
      self.class.print_tile(@tile)
    end

    def self.print_tile(tile)
      tile.to_a.map { |row| row.to_a.map { |pixel| pixel.zero? ? '.' : '#' }.join }.join("\n")
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
