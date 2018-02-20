# frozen-string-literal: true

module Warabi
  class MediatorStack
    attr_reader :mediator

    def initialize(mediator = Mediator.new)
      @stack = []
      @mediator = mediator
    end

    def context_new(&block)
      stack_push
      begin
        yield self
      ensure
        stack_pop
      end
    end

    def stack_push
      @stack.push(@mediator)
      @mediator = @mediator.deep_dup
    end

    def stack_pop
      if @stack.empty?
        raise MementoStackEmpty
      end
      @mediator = @stack.pop
    end
  end
end
