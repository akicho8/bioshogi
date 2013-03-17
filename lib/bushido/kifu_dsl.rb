# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/pattern_spec.rb" -*-
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

      def dump
        :push
      end
    end

    class Pop < Expression
      def evaluate(context)
        context.stack_pop
      end

      def dump
        :pop
      end
    end

    class Mov < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        Utils.__ki2_input_seq_parse(@value)
      end

      def dump
        [:mov, Utils.__ki2_input_seq_parse(@value)]
      end
    end

    class Title < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        context.set(:title, @value)
      end

      def dump
        [:title, @value]
      end
    end

    class Comment < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        context.set(:comment, @value)
      end

      def dump
        [:comment, @value]
      end
    end

    class Pieces < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        @value.each{|k, v|context.player_at(k).deal(v)}
      end

      def dump
        [:pieces, @value]
      end
    end

    class Board < Expression
      def initialize(value = nil)
        @value = value
      end

      def evaluate(context)
        context.board_reset(@value)
      end

      def dump
        [:board, @value]
      end
    end

    class Mov < Expression
      def initialize(value)
        @value = value
      end

      def evaluate(context)
        Utils.__ki2_input_seq_parse(@value).each do |hash|
          player = context.player_at(hash[:location])
          player.execute(hash[:input])
          # context.log_stock(player)
          context.frames << context.deep_dup
        end
      end

      def dump
        [:mov, Utils.__ki2_input_seq_parse(@value)]
      end
    end

    def self.build(&block)
      new.tap{|e|e.instance_eval(&block)}
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
  end

  if $0 == __FILE__
    require "../bushido"
    require "pp"
    builder = KifuDsl.build do
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
