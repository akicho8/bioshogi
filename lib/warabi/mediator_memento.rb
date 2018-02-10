# frozen-string-literal: true

module Warabi
  class MediatorMemento
    attr_reader :mediator

    def initialize(mediator = Mediator.new)
      @stack = []
      @mediator = mediator
    end

    def create
      @stack.push(@mediator.deep_dup)
    end
    alias stack_push create

    def restore
      if @stack.empty?
        raise HistroyStackEmpty
      end
      @mediator = @stack.pop
    end
    alias stack_pop restore

    def context_new(&block)
      create
      begin
        yield self
      ensure
        restore
      end
    end
  end
end
