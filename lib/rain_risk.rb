# frozen_string_literal: true

require_relative 'file_helper'

# Solution for https://adventofcode.com/2020/day/12

class RainRisk
  def self.manhattan_distance(commands, ferry: PointFerry.new)
    commands.each { |command| ferry.execute(command) }
    ferry.coordinates.x.abs + ferry.coordinates.y.abs
  end

  module Ferry
    COMMAND_PATTERN = /^(?<direction>\w)(?<value>\d+)$/.freeze

    attr_reader :coordinates

    def initialize
      @coordinates = Coordinates.new(0, 0)
    end

    def execute(raw_command)
      command = parse_command(raw_command)
      execute_parsed_command(command)
    end

    private

    def execute_parsed_command(command)
      case command.direction
      when 'F'
        move_forward(command.value)
      when 'R'
        rotate(command.value)
      when 'L'
        rotate(-command.value)
      else
        move_to_direction(command.direction, command.value)
      end
    end

    def parse_command(raw_command)
      command_match = COMMAND_PATTERN.match(raw_command)
      direction = command_match[:direction]
      value = command_match[:value].to_i
      Command.new(direction, value)
    end

    Command = Struct.new(:direction, :value)
  end

  class PointFerry
    include Ferry

    attr_reader :orientation

    def initialize
      super
      @orientation = Directions::EAST
    end

    def move_forward(value)
      move_to_direction(orientation, value)
    end

    def move_to_direction(direction, value)
      @coordinates += INCREMENTS_BY_DIRECTION[direction].call(value)
    end

    def rotate(value)
      @orientation = Directions.rotate(orientation, value)
    end
  end

  class WaypointFerry
    include Ferry

    attr_reader :waypoint

    def initialize
      super
      @waypoint = Coordinates.new(10, 1)
    end

    def move_forward(value)
      @coordinates += waypoint * value
    end

    def move_to_direction(direction, value)
      @waypoint += INCREMENTS_BY_DIRECTION[direction].call(value)
    end

    def rotate(value)
      @waypoint = if value.negative?
                    ROTATION[360 + value].call(waypoint)
                  else
                    ROTATION[value].call(waypoint)
                  end
    end

    ROTATION = {
      90 => ->(coordinates) { Coordinates.new(coordinates.y, -coordinates.x) },
      180 => ->(coordinates) { Coordinates.new(-coordinates.x, -coordinates.y) },
      270 => ->(coordinates) { Coordinates.new(-coordinates.y, coordinates.x) }
    }.freeze
  end

  module Directions
    EAST = 'E'
    WEST = 'W'
    NORTH = 'N'
    SOUTH = 'S'
    ALL = [NORTH, EAST, SOUTH, WEST].freeze

    def self.rotate(current_coordinates, degrees)
      current_direction_index = ALL.find_index(current_coordinates)
      next_direction_index = (current_direction_index + (degrees / 90)) % ALL.length
      ALL[next_direction_index]
    end
  end

  Coordinates = Struct.new(:x, :y) do
    def +(other)
      Coordinates.new(x + other.x, y + other.y)
    end

    def *(other)
      Coordinates.new(x * other, y * other)
    end
  end

  INCREMENTS_BY_DIRECTION = {
    Directions::NORTH => ->(value) { Coordinates.new(0, value) },
    Directions::SOUTH => ->(value) { Coordinates.new(0, -value) },
    Directions::WEST => ->(value) { Coordinates.new(-value, 0) },
    Directions::EAST => ->(value) { Coordinates.new(value, 0) }
  }.freeze
end
