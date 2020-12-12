# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/rain_risk'

class RainRiskTest < Minitest::Test
  def test_rotate
    current_orientation = RainRisk::Direction::EAST
    assert_equal(RainRisk::Direction::EAST, RainRisk::Direction.rotate(current_orientation, 0))
    assert_equal(RainRisk::Direction::SOUTH, RainRisk::Direction.rotate(current_orientation, 90))
    assert_equal(RainRisk::Direction::NORTH, RainRisk::Direction.rotate(current_orientation, -90))
    assert_equal(RainRisk::Direction::WEST, RainRisk::Direction.rotate(current_orientation, 180))
    assert_equal(RainRisk::Direction::WEST, RainRisk::Direction.rotate(current_orientation, -180))
    assert_equal(RainRisk::Direction::NORTH, RainRisk::Direction.rotate(current_orientation, 270))
    assert_equal(RainRisk::Direction::SOUTH, RainRisk::Direction.rotate(current_orientation, -270))
    assert_equal(RainRisk::Direction::EAST, RainRisk::Direction.rotate(current_orientation, 360))
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def test_commands
    ferry = RainRisk::Ferry.new
    assert_equal(RainRisk::Position.new(0, 0), ferry.position)
    assert_equal(RainRisk::Direction::EAST, ferry.orientation)

    ferry.execute('F10')
    assert_equal(RainRisk::Position.new(10, 0), ferry.position)
    assert_equal(RainRisk::Direction::EAST, ferry.orientation)

    ferry.execute('R90')
    ferry.execute('F5')
    assert_equal(RainRisk::Position.new(10, -5), ferry.position)
    assert_equal(RainRisk::Direction::SOUTH, ferry.orientation)

    ferry.execute('L270')
    ferry.execute('F3')
    assert_equal(RainRisk::Position.new(7, -5), ferry.position)
    assert_equal(RainRisk::Direction::WEST, ferry.orientation)

    commands = %w[F10 N3 F7 R90 F11]
    assert_equal(25, RainRisk.manhattan_distance(commands))
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def test_first_puzzle
    commands = File.readlines('./lib/rain_risk.txt')
    assert_equal(759, RainRisk.manhattan_distance(commands))
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def test_waypoint_ferry
    ferry = RainRisk::WaypointFerry.new

    ferry.execute('F10')
    assert_equal(RainRisk::Position.new(100, 10), ferry.position)
    assert_equal(RainRisk::Position.new(10, 1), ferry.waypoint)

    ferry.execute('N3')
    assert_equal(RainRisk::Position.new(100, 10), ferry.position)
    assert_equal(RainRisk::Position.new(10, 4), ferry.waypoint)

    ferry.execute('F7')
    assert_equal(RainRisk::Position.new(170, 38), ferry.position)
    assert_equal(RainRisk::Position.new(10, 4), ferry.waypoint)

    ferry.execute('R90')
    assert_equal(RainRisk::Position.new(170, 38), ferry.position)
    assert_equal(RainRisk::Position.new(4, -10), ferry.waypoint)

    ferry.execute('F11')
    assert_equal(RainRisk::Position.new(214, -72), ferry.position)
    assert_equal(RainRisk::Position.new(4, -10), ferry.waypoint)

    commands = %w[F10 N3 F7 R90 F11]
    assert_equal(286, RainRisk.manhattan_distance(commands, ferry: RainRisk::WaypointFerry.new))
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def test_second_puzzle
    commands = File.readlines('./lib/rain_risk.txt')
    assert_equal(45_763, RainRisk.manhattan_distance(commands, ferry: RainRisk::WaypointFerry.new))
  end
end
