# frozen-string-literal: true

module Warabi
  class Dsl
    class Expression
      def evaluate(context)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def dump
        [self.class.name.underscore]
      end
    end

    class Push < Expression
      def evaluate(context)
        context.mediator_memento.stack_push
      end
    end

    class Pop < Expression
      def evaluate(context)
        context.mediator_memento.stack_pop
      end
    end

    class VarPush < Expression
      def initialize(key)
        @key = key
      end

      def evaluate(context)
        context.mediator_memento.mediator.var_push(@key)
      end
    end

    class VarPop < Expression
      def initialize(key)
        @key = key
      end

      def evaluate(context)
        context.mediator_memento.mediator.var_pop(@key)
      end
    end

    class VarSet < Expression
      def initialize(key, value)
        @key = key
        @value = value
      end

      def evaluate(context)
        context.mediator_memento.mediator.variables[@key] = @value
      end
    end

    class Pieces < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        @value.each do |k, v|
          context.mediator_memento.mediator.player_at(k).pieces_add(v)
        end
      end
    end

    class Board < Expression
      def initialize(value = nil)
        @value = value
      end

      def evaluate(context)
        context.mediator_memento.mediator.board_reset_any(@value)
      end
    end

    class Mov < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        Soldier.movs_split(@value).each do |str|
          context.mediator_memento.mediator.execute(str)
          if context.mediator_memento.mediator.variables[:auto_flushing]
            context.snapshots << context.mediator_memento.mediator.deep_dup
            context.mediator_memento.mediator.set(:comment, nil)
          end
        end
      end
    end

    class Snapshot < Expression
      def initialize(value = nil)
        @value = value
      end

      def evaluate(context)
        if @value
          context.mediator_memento.mediator.set(:comment, @value)
        end
        context.snapshots << context.mediator_memento.mediator.deep_dup
        context.mediator_memento.mediator.set(:comment, nil)
      end
    end

    def self.define(*args, &block)
      new.tap do |e|
        e.instance_exec(*args, &block)
      end
    end

    attr_reader :sequence

    def initialize
      @sequence = []
    end

    def evaluate(*args)
      @sequence.each do |e|
        e.evaluate(*args)
      end
    end

    def dump(*args)
      @sequence.collect do |e|
        e.dump(*args)
      end
    end

    def mov(*args)
      @sequence << Mov.new(*args)
    end

    def push(&block)
      @sequence << Push.new
      if block_given?
        instance_eval(&block)
        pop
      end
    end

    def pop
      @sequence << Pop.new
    end

    def set(*args)
      @sequence << VarSet.new(*args)
    end

    def title(*args)
      @sequence << VarSet.new(:title, *args)
    end

    def comment(*args)
      @sequence << VarSet.new(:comment, *args)
    end

    def pieces(*args)
      @sequence << Pieces.new(*args)
    end

    def board(*args)
      @sequence << Board.new(*args)
    end

    def snapshot(*args)
      @sequence << Snapshot.new(*args)
    end

    def auto_flushing(value = true, &block)
      local_vars(auto_flushing: value, &block)
    end

    def local_vars(attrs, &block)
      if block_given?
        attrs.each do |key, value|
          @sequence << VarPush.new(key)
          set(key, value)
        end
        instance_eval(&block)
        attrs.reverse_each do |key, value|
          @sequence << VarPop.new(key)
        end
      else
        attrs.each do |key, value|
          set(key, value)
        end
      end
    end
  end
end
