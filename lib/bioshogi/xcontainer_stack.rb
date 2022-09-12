# frozen-string-literal: true

module Bioshogi
  class XcontainerStack
    attr_reader :xcontainer

    def initialize(xcontainer = Xcontainer.new)
      @stack = []
      @xcontainer = xcontainer
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
      @stack.push(@xcontainer)
      @xcontainer = @xcontainer.deep_dup
    end

    def stack_pop
      if @stack.empty?
        raise MementoStackEmpty
      end
      @xcontainer = @stack.pop
    end
  end
end
