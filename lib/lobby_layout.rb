# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/24

class LobbyLayout
  INCREMENTS = {
    e: [1, -1],
    w: [-1, 1],
    se: [1, 0],
    nw: [-1, 0],
    sw: [0, 1],
    ne: [0, -1]
  }.freeze

  attr_reader :black_tiles

  def initialize
    @black_tiles = Set.new
  end

  def flip(tile_path)
    tile_position = tile_position_for(tile_path)
    if black_tiles.include?(tile_position)
      black_tiles.delete(tile_position)
    else
      black_tiles << tile_position
    end
  end

  private

  def tile_position_for(tile_path)
    tile_path
      .scan(/(e)|(w)|(se)|(ne)|(nw)|(sw)/)
      .map(&:compact)
      .flatten
      .map { |direction| INCREMENTS[direction.to_sym] }
      .reduce([0, 0]) { |position, increment| [position.first + increment.first, position.last + increment.last] }
  end
end
