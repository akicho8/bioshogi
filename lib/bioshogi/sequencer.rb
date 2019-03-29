# frozen-string-literal: true

module Bioshogi
  class Sequencer
    attr_accessor :snapshots
    attr_accessor :pattern
    attr_accessor :instruction_placeer
    attr_accessor :mediator_stack

    def initialize(pattern = nil)
      super()

      @pattern = pattern
      @snapshots = []
      @instruction_placeer = 0
      @mediator_stack = MediatorStack.new
    end

    # def pattern=(block)
    #   if block.kind_of? Proc
    #     @pattern = NotationDsl.define(&block)
    #   else
    #     @pattern = block
    #   end
    # end

    def evaluate
      @pattern.evaluate(self)
    end

    def step_evaluate
      expr = nil
      loop do
        expr = @pattern.sequence[@instruction_placeer]
        unless expr
          break
        end
        @instruction_placeer += 1
        expr.evaluate(self)
        if expr.kind_of?(NotationDsl::Mov)
          break
        end
      end
      expr
    end
  end
end
