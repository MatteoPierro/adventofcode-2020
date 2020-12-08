# frozen_string_literal: true

module Assembly
  module Instructions
    module Instruction
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def execute(state)
        apply(state)
        next_instruction
      end

      def apply(_state); end

      def next_instruction
        1
      end

      def swap
        self
      end

      def swappable?
        false
      end
    end

    class Nop
      include Instruction

      def swap
        Jmp.new(value)
      end

      def swappable?
        true
      end
    end

    class Jmp
      include Instruction

      def next_instruction
        @value
      end

      def swap
        Nop.new(value)
      end

      def swappable?
        true
      end
    end

    class Acc
      include Instruction

      def apply(state)
        state.accumulator += @value
      end
    end
  end
end
