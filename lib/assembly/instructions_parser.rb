# frozen_string_literal: true

module Assembly
  module Instructions
    module Parser
      class << self
        def parse_instructions(raw_instructions)
          raw_instructions.map(&method(:parse_instruction))
        end

        # rubocop:disable Metrics/MethodLength
        def parse_instruction(raw_instruction)
          match = raw_instruction.match(/^(?<name>.*) (?<value>.*)$/)
          name = match[:name]
          value = match[:value].to_i
          case name
          when 'nop'
            Nop.new(value)
          when 'acc'
            Acc.new(value)
          when 'jmp'
            Jmp.new(value)
          else
            raise "Unexpected instruction #{name} with value #{value}"
          end
        end

        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
