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

  def evolve
    new_black_tiles = Set.new
    black_tiles.each do |black_tile|
      white_neighbours, black_neighbours = neighbours(black_tile)
      new_black_tiles << black_tile if [1, 2].include?(black_neighbours.length)
      new_neighbours_black(white_neighbours, new_black_tiles)
    end
    @black_tiles = new_black_tiles
  end

  private

  def new_neighbours_black(white_neighbours, new_black_tiles)
    white_neighbours.each do |white_tile|
      _, black_neighbours = neighbours(white_tile)
      new_black_tiles << white_tile if black_neighbours.length == 2
    end
  end

  def neighbours(tile)
    neighbours = INCREMENTS
                 .values
                 .map { |increment| [tile.first + increment.first, tile.last + increment.last] }
                 .group_by { |neighbour| black_tiles.include?(neighbour) }
    [neighbours[false] || [], neighbours[true] || []]
  end

  def tile_position_for(tile_path)
    tile_path
      .scan(/(e)|(w)|(se)|(ne)|(nw)|(sw)/)
      .map(&:compact)
      .flatten
      .map { |direction| INCREMENTS[direction.to_sym] }
      .reduce([0, 0]) { |position, increment| [position.first + increment.first, position.last + increment.last] }
  end
end
