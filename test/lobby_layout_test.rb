# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/lobby_layout'

class LobbyLayoutTest < Minitest::Test
  def test_flip
    lobby_layout = LobbyLayout.new
    lobby_layout.flip('nwwswee')
    assert_equal(Set[[0, 0]], lobby_layout.black_tiles)
    lobby_layout.flip('nwwswee')
    assert(lobby_layout.black_tiles.empty?)
  end

  def test_count_black_tiles
    tiles_paths = File.readlines('./test/lobby_layout_test.txt')
    lobby_layout = LobbyLayout.new

    tiles_paths.each { |tile_path| lobby_layout.flip(tile_path) }

    assert_equal(10, lobby_layout.black_tiles.count)
  end

  def test_first_puzzle
    tiles_paths = File.readlines('./lib/lobby_layout.txt')
    lobby_layout = LobbyLayout.new

    tiles_paths.each { |tile_path| lobby_layout.flip(tile_path) }

    assert_equal(391, lobby_layout.black_tiles.count)
  end
end
