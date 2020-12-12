# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/12

class RainRisk
  def self.manhattan_distance(commands, ferry: Ferry.new)
    commands.each { |command| ferry.execute(command) }
    ferry.position.x.abs + ferry.position.y.abs
  end

  class Ferry
    COMMAND_PATTERN = /^(?<command>\w)(?<value>\d+)$/.freeze

    attr_reader :position, :orientation

    def initialize
      @position = Position.new(0, 0)
      @orientation = Direction::EAST
    end

    # rubocop:disable Metrics/MethodLength
    def execute(raw_command)
      command_match = COMMAND_PATTERN.match(raw_command)
      command = command_match[:command]
      value = command_match[:value].to_i
      case command
      when 'F'
        @position += INCREMENTS_BY_DIRECTION[orientation].call(value)
      when 'R'
        @orientation = Direction.rotate(orientation, value)
      when 'L'
        @orientation = Direction.rotate(orientation, -value)
      else
        @position += INCREMENTS_BY_DIRECTION[command].call(value)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end

  class WaypointFerry
    COMMAND_PATTERN = /^(?<command>\w)(?<value>\d+)$/.freeze

    attr_reader :position, :waypoint

    def initialize
      @position = Position.new(0, 0)
      @waypoint = Position.new(10, 1)
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def execute(raw_command)
      command_match = COMMAND_PATTERN.match(raw_command)
      command = command_match[:command]
      value = command_match[:value].to_i
      case command
      when 'F'
        @position += waypoint * value
      when 'R'
        @waypoint = ROTATION[value].call(waypoint)
      when 'L'
        @waypoint = ROTATION[360 - value].call(waypoint)
      else
        @waypoint += INCREMENTS_BY_DIRECTION[command].call(value)
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    ROTATION = {
      90 => ->(position) { Position.new(position.y, -position.x) },
      180 => ->(position) { Position.new(-position.x, -position.y) },
      270 => ->(position) { Position.new(-position.y, position.x) },
      360 => ->(position) { position }
    }.freeze
  end

  module Direction
    EAST = 'E'
    WEST = 'W'
    NORTH = 'N'
    SOUTH = 'S'
    ALL = [NORTH, EAST, SOUTH, WEST].freeze

    def self.rotate(current_position, degrees)
      current_direction_index = ALL.find_index(current_position)
      next_direction_index = (current_direction_index + (degrees / 90)) % ALL.length
      ALL[next_direction_index]
    end
  end

  Position = Struct.new(:x, :y) do
    def +(other)
      Position.new(x + other.x, y + other.y)
    end

    def *(other)
      Position.new(x * other, y * other)
    end
  end

  INCREMENTS_BY_DIRECTION = {
    Direction::NORTH => ->(value) { Position.new(0, value) },
    Direction::SOUTH => ->(value) { Position.new(0, -value) },
    Direction::WEST => ->(value) { Position.new(-value, 0) },
    Direction::EAST => ->(value) { Position.new(value, 0) }
  }.freeze
end