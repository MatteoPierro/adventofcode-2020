# frozen_string_literal: true

module Assembly
  class Machine
    def self.execute(instructions)
      state = State.new
      Machine.new(state).execute(instructions)
      state
    end

    def initialize(state)
      @state = state
    end

    # rubocop:disable Metrics/MethodLength
    def execute(instructions)
      used_instructions = []
      instruction_index = 0
      loop do
        instruction = instructions[instruction_index]
        if used_instructions.include?(instruction)
          @state.loop_detected!
          break
        end

        used_instructions << instruction
        instruction_index += instruction.execute(@state)
        break if instruction_index >= instructions.length
      end
    end
    # rubocop:enable Metrics/MethodLength

    class State
      attr_accessor :accumulator, :loop_detected

      def initialize
        @accumulator = 0
        @loop_detected = false
      end

      def loop_detected!
        @loop_detected = true
      end

      def loop_detected?
        @loop_detected
      end
    end
  end
end
