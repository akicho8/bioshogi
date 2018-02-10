# frozen-string-literal: true

module Warabi
  class Sequencer
    attr_accessor :snapshots
    attr_accessor :pattern
    attr_accessor :instruction_pointer
    attr_accessor :mediator_memento

    def initialize(pattern = nil)
      super()

      @pattern = pattern
      @snapshots = []
      @instruction_pointer = 0
      @mediator_memento = MediatorMemento.new
    end

    # def pattern=(block)
    #   if block.kind_of? Proc
    #     @pattern = Dsl.define(&block)
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
        expr = @pattern.sequence[@instruction_pointer]
        unless expr
          break
        end
        @instruction_pointer += 1
        expr.evaluate(self)
        if expr.kind_of?(Dsl::Mov)
          break
        end
      end
      expr
    end
  end
end
