# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_dsl_spec.rb" -*-
#
# 棋譜ビルダー
#   テキストをがんばってパースするぐらいならDSLにする方がいい、という考えから生まれているので、
#   DSLが書きにくいなら、生のコードで書くことになる。
#   既存のKIFのテキストだけで書くのは拡張性にかけるのでだめ
#   stackブロックを指定して最初から詰みまで書けるようにする

module Bushido
  class KifuDsl
    class Expression
      def dump
        [self.class.name.underscore]
      end
    end

    class Push < Expression
      def evaluate(context)
        context.stack_push
      end
    end

    class Pop < Expression
      def evaluate(context)
        context.stack_pop
      end
    end

    # class AutoFlushing < Expression
    #   def initialize(value = nil)
    #     @value = value
    #   end
    #
    #   def evaluate(context)
    #     context.variables[:auto_flushing] = @
    #   end
    #
    #   def dump
    #     :push
    #   end
    # end

    class VarPush < Expression
      def initialize(key)
        @key = key
      end

      def evaluate(context)
        context.var_push(@key)
      end
    end

    class VarPop < Expression
      def initialize(key)
        @key = key
      end

      def evaluate(context)
        context.var_pop(@key)
      end
    end

    class Set < Expression
      def initialize(key, value)
        @key = key
        @value = value
      end

      def evaluate(context)
        context.variables[@key] = @value
      end
    end

    class Title < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        context.variables[:title] = @value
      end
    end

    class Comment < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        context.variables[:comment] = @value
      end
    end

    class Pieces < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        @value.each{|k, v|context.player_at(k).deal(v)}
      end
    end

    class Board < Expression
      def initialize(value = nil)
        @value = value
      end

      def evaluate(context)
        context.board_reset(@value)
      end
    end

    # TODO: silent_mov も作る

    class Mov < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        Utils.safe_ki2_parse(@value).each do |hash|
          player = context.player_at(hash[:location])
          player.execute(hash[:input])
          if context.variables[:auto_flushing]
            context.frames << context.deep_dup
            context.set(:comment, nil)
          end
        end
      end
    end

    class Disp < Expression
      def initialize(value = nil)
        @value = value
      end

      def evaluate(context)
        if @value
          context.set(:comment, @value)
        end
        context.frames << context.deep_dup
        context.set(:comment, nil)
      end
    end

    def self.define(*args, &block)
      new.tap{|e|e.instance_exec(*args, &block)}
    end

    attr_reader :seqs

    def initialize
      @seqs = []
    end

    def evaluate(*args)
      @seqs.collect{|seq|seq.evaluate(*args)}
    end

    # def step(index)
    #   @seqs[index].collect{|seq|seq.evaluate(*args)}
    # end

    def dump(*args)
      @seqs.collect{|seq|seq.dump(*args)}
    end

    def mov(*args)
      @seqs << Mov.new(*args)
    end

    def push(&block)
      @seqs << Push.new
      if block_given?
        instance_eval(&block)
        pop
      end
    end

    def pop
      @seqs << Pop.new
    end

    def auto_flushing(value = true, &block)
      local_vars(:auto_flushing => value, &block)

      # if block_given?
      #   @seqs << VarPush.new(:auto_flushing)
      #   set(:auto_flushing, value)
      #   instance_eval(&block)
      #   @seqs << VarPop.new(:auto_flushing)
      # else
      #   set(:auto_flushing, value)
      # end
    end

    # def local_var(key, value, &block)
    #   if block_given?
    #     @seqs << VarPush.new(:auto_flushing)
    #     set(:auto_flushing, value)
    #     instance_eval(&block)
    #     @seqs << VarPop.new(:auto_flushing)
    #   else
    #     set(:auto_flushing, value)
    #   end
    # end

    def local_vars(attrs, &block)
      if block_given?
        attrs.each{|k, v|
          @seqs << VarPush.new(k)
          set(k, v)
        }
        instance_eval(&block)
        attrs.reverse_each{|k, v|
          @seqs << VarPop.new(k)
        }
      else
        attrs.each{|k, v|
          set(k, v)
        }
      end
    end

    def set(*args)
      @seqs << Set.new(*args)
    end

    def title(*args)
      @seqs << Title.new(*args)
    end

    def comment(*args)
      @seqs << Comment.new(*args)
    end

    def pieces(*args)
      @seqs << Pieces.new(*args)
    end

    def board(*args)
      @seqs << Board.new(*args)
    end

    def snapshot(*args)
      @seqs << Disp.new(*args)
    end
  end

  if $0 == __FILE__
    require "../bushido"
    require "pp"
    builder = KifuDsl.define do
      title "(title)"
      comment "(comment)"
      pieces :black => "歩"
      board "平手"
      mov "▲７六歩", "▲２六歩"
      mov "△３四歩"
      # push
      # mov "▲７六歩"
      # mov "△３四歩"
      # pop
    end
    # pp builder.evaluate
    pp builder.dump
  end
end
