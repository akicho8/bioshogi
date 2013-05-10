# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/piece_spec.rb" -*-
#
# 駒
#   Piece["歩"].name  # => "歩"
#   Piece[:pawn].name # => "歩"
#   Piece.each{|piece|...}
#

require "singleton"

module Bushido
  class Piece
    include Singleton

    class << self
      include Enumerable

      private :instance

      def each(&block)
        instance.pool.each(&block)
      end

      # get(arg) の alias
      def [](arg)
        get(arg)
      end

      # 駒オブジェクトを得る
      #   Piece.get(nil)       # => nil
      #   Piece.get("歩").name # => "歩"
      #   Piece.get("と").name # => "歩"
      #   「と」も「歩」も区別しない。区別したい場合は promoted_fetch を使うこと
      #   エラーにしたいときは fetch を使う
      def get(arg)
        basic_get(arg) || promoted_get(arg)
      end

      # Piece.fetch("歩").name # => "歩"
      # Piece.fetch("卍")      # => PieceNotFound
      def fetch(arg)
        get(arg) or raise PieceNotFound, "#{arg.inspect} に対応する駒がない"
      end

      # 「歩」や「と」を駒オブジェクトと成フラグに分離
      #   Piece.promoted_fetch("歩") # => <MiniSoldier piece:"歩">
      #   Piece.promoted_fetch("と") # => <MiniSoldier piece:"歩", promoted: true>
      def promoted_fetch(arg)
        case
        when piece = basic_get(arg)
          MiniSoldier[piece: piece]
        when piece = promoted_get(arg)
          MiniSoldier[piece: piece, promoted: true]
        else
          raise PieceNotFound, "#{arg.inspect} に対応する駒がない"
        end
      end

      def names
        collect(&:names).flatten
      end

      # 台上の持駒文字列をハッシュ配列化
      #   hold_pieces_str_to_array("飛 香二") # => [{piece: Piece["飛"], count: 1}, {piece: Piece["香"], count: 2}]
      def hold_pieces_str_to_array(*args)
        Utils.hold_pieces_str_to_array(*args)
      end

      private

      def basic_get(arg)
        find{|piece|piece.basic_names.include?(arg.to_s)}
      end

      def promoted_get(arg)
        find{|piece|piece.promoted_names.include?(arg.to_s)}
      end
    end

    attr_reader :pool

    def initialize
      @pool = [:pawn, :bishop, :rook, :lance, :knight, :silver, :gold, :king].collect{|key|
        "Bushido::Piece::#{key.to_s.classify}".constantize.new
      }
    end

    # 駒共通クラス
    #
    # ここで == を定義すると面倒なことになるので注意。
    # 持駒の歩を取り出すため `player.pieces.delete(Piece["歩"])' としたとき歩が全部消えてしまう。
    # 同じ種類の駒、同じ種類の別の駒を分けて判別するためには == を定義しない方がいい。
    class Base
      module NameMethods
        def some_name(promoted)
          if promoted
            promoted_name
          else
            name
          end
        end

        def name
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def sym_name
          self.class.name.demodulize.underscore.to_sym
        end

        def promoted_name
        end

        def names
          basic_names + promoted_names
        end

        def basic_names
          [name, sym_name.to_s]
        end

        def promoted_names
          [promoted_name, sym_name.to_s.upcase].compact
        end
      end

      include NameMethods

      module VectorMethods
        # ベクトル取得の唯一の外部インタフェース
        def select_vectors(promoted = false)
          assert_promotable(promoted)
          promoted ? promoted_vectors : basic_vectors
        end

        private

        # オーバーライド用
        begin
          # 通常の1ベクトル
          def basic_once_vectors
            []
          end

          # 通常の繰り返しベクトル
          def basic_repeat_vectors
            []
          end

          # 成ったときの1ベクトル
          def promoted_once_vectors
            []
          end

          # 成ったときの繰り返しベクトル
          def promoted_repeat_vectors
            []
          end
        end

        # 通常の合成ベクトル
        def basic_vectors
          build_vectors(basic_once_vectors, basic_repeat_vectors)
        end

        # 成ったときの合成ベクトル
        def promoted_vectors
          build_vectors(promoted_once_vectors, promoted_repeat_vectors)
        end

        def build_vectors(ov, rv)
          Set[*(ov.compact.collect{|v|OnceVector[*v]} + rv.compact.collect{|v|RepeatVector[*v]})]
        end
      end

      include VectorMethods

      def promotable?
        true
      end

      def assert_promotable(promoted)
        if !promotable? && promoted
          raise NotPromotable
        end
      end

      def inspect
        "<#{self.class.name}:#{object_id} #{name} #{sym_name}>"
      end

      def to_h
        [
          :name,
          :promoted_name,
          :basic_names,
          :promoted_names,
          :names,
          :sym_name,
          :promotable?,
          :basic_once_vectors,
          :basic_repeat_vectors,
          :promoted_once_vectors,
          :promoted_repeat_vectors,
        ].inject({}){|h, key|h.merge(key => send(key))}
      end
    end

    module Pattern
      extend self

      def pattern_plus
        [
          nil,    [0,-1],   nil,
          [-1, 0],       [1, 0],
          nil,    [0, 1],   nil,
        ]
      end

      def pattern_x
        [
          [-1, -1], nil, [1, -1],
          nil,      nil,     nil,
          [-1,  1], nil, [1,  1],
        ]
      end
    end

    module Goldable
      private
      def promoted_once_vectors
        Gold.basic_pattern
      end
    end

    module Brave
      private
      def promoted_repeat_vectors
        basic_repeat_vectors
      end
    end

    class Pawn < Base
      include Goldable

      def name
        "歩"
      end

      def promoted_name
        "と"
      end

      private

      def basic_once_vectors
        [[0, -1]]
      end
    end

    class Bishop < Base
      include Brave

      def name
        "角"
      end

      def promoted_name
        "馬"
      end

      private

      def promoted_once_vectors
        Pattern.pattern_plus
      end

      def basic_repeat_vectors
        Pattern.pattern_x
      end
    end

    class Rook < Base
      include Brave

      def name
        "飛"
      end

      def promoted_name
        "龍"
      end

      def promoted_names
        super + ["竜"]
      end

      private

      def promoted_once_vectors
        Pattern.pattern_x
      end

      def basic_repeat_vectors
        Pattern.pattern_plus
      end
    end

    class Lance < Base
      include Goldable

      def name
        "香"
      end

      def promoted_name
        "杏"
      end

      def promoted_names
        super + ["成香"]
      end

      private

      def basic_repeat_vectors
        [[0, -1]]
      end
    end

    class Knight < Base
      include Goldable

      def name
        "桂"
      end

      def promoted_name
        "圭"
      end

      def promoted_names
        super + ["成桂"]
      end

      private

      def basic_once_vectors
        [[-1, -2], [1, -2]]
      end
    end

    class Silver < Base
      include Goldable

      def name
        "銀"
      end

      def promoted_name
        "全"
      end

      def promoted_names
        super + ["成銀"]
      end

      private

      def basic_once_vectors
        [
          [-1, -1], [0, -1], [1, -1],
          nil,          nil,     nil,
          [-1,  1],     nil, [1,  1],
        ]
      end
    end

    class Gold < Base
      def self.basic_pattern
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ]
      end

      def name
        "金"
      end

      def promotable?
        false
      end

      private

      def basic_once_vectors
        self.class.basic_pattern
      end
    end

    class King < Base
      def self.basic_pattern
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],     nil, [1,  0],
          [-1,  1], [0,  1], [1,  1],
        ]
      end

      def name
        "玉"
      end

      def basic_names
        super + ["王"]
      end

      def promotable?
        false
      end

      private

      def basic_once_vectors
        self.class.basic_pattern
      end
    end
  end
end
