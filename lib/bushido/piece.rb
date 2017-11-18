# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/piece_spec.rb" -*-
#
# 駒
#   Piece["歩"].name  # => "歩"
#   Piece[:pawn].name # => "歩"
#   Piece.each{|piece|...}
#
# 意味
#   basic_once_vectors      通常の1ベクトル
#   basic_repeat_vectors    通常の繰り返しベクトル
#   promoted_once_vectors   成ったときの1ベクトル
#   promoted_repeat_vectors 成ったときの繰り返しベクトル
#
# 注意点
#   == を定義すると面倒なことになる
#   持駒の歩を取り出すため `player.pieces.delete(Piece["歩"])' としたとき歩が全部消えてしまう
#   同じ種類の駒、同じ種類の別の駒を分けて判別するためには == を定義しない方がいい
#

module Bushido
  class Piece
    include MemoryRecord
    memory_record [
      {key: :king,   name: "玉", basic_alias: "王", promoted_name: nil,  promoted_alias: nil,    csa_name1: "OU", csa_name2: nil,  basic_once_vectors: :pattern_king,       basic_repeat_vectors: nil,            promotable: false, promoted_once_vectors: nil,           promoted_repeat_vectors: nil},
      {key: :gold,   name: "金", basic_alias: nil,  promoted_name: nil,  promoted_alias: nil,    csa_name1: "KI", csa_name2: nil,  basic_once_vectors: :pattern_gold,       basic_repeat_vectors: nil,            promotable: false, promoted_once_vectors: nil,           promoted_repeat_vectors: nil},
      {key: :silver, name: "銀", basic_alias: nil,  promoted_name: "全", promoted_alias: "成銀", csa_name1: "GI", csa_name2: "NG", basic_once_vectors: :pattern_silver,     basic_repeat_vectors: nil,            promotable: true,  promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil},
      {key: :knight, name: "桂", basic_alias: nil,  promoted_name: "圭", promoted_alias: "成桂", csa_name1: "KE", csa_name2: "NK", basic_once_vectors: [[-1, -2], [1, -2]], basic_repeat_vectors: nil,            promotable: true,  promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil},
      {key: :lance,  name: "香", basic_alias: nil,  promoted_name: "杏", promoted_alias: "成香", csa_name1: "KY", csa_name2: "NY", basic_once_vectors: nil,                 basic_repeat_vectors: [[0, -1]],     promotable: true,  promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil},
      {key: :bishop, name: "角", basic_alias: nil,  promoted_name: "馬", promoted_alias: nil,    csa_name1: "KA", csa_name2: "UM", basic_once_vectors: nil,                 basic_repeat_vectors: :pattern_x,    promotable: true,  promoted_once_vectors: :pattern_plus, promoted_repeat_vectors: :pattern_x},
      {key: :rook,   name: "飛", basic_alias: nil,  promoted_name: "龍", promoted_alias: "竜",   csa_name1: "HI", csa_name2: "RY", basic_once_vectors: nil,                 basic_repeat_vectors: :pattern_plus, promotable: true,  promoted_once_vectors: :pattern_x,    promoted_repeat_vectors: :pattern_plus},
      {key: :pawn,   name: "歩", basic_alias: nil,  promoted_name: "と", promoted_alias: nil,    csa_name1: "FU", csa_name2: "TO", basic_once_vectors: [[0, -1]],           basic_repeat_vectors: nil,            promotable: true,  promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil},
    ]

    class << self
      prepend Module.new {
        # 駒オブジェクトを得る
        #   Piece.get(nil)       # => nil
        #   Piece.get("歩").name # => "歩"
        #   Piece.get("と").name # => "歩"
        #   「と」も「歩」も区別しない。区別したい場合は promoted_fetch を使うこと
        #   エラーにしたいときは fetch を使う
        def lookup(arg)
          super || basic_get(arg) || promoted_get(arg)
        end

        alias [] lookup

        alias get lookup

        # Piece.fetch("歩").name # => "歩"
        # Piece.fetch("卍")      # => PieceNotFound
        def fetch(arg)
          lookup(arg) or raise PieceNotFound, "#{arg.inspect} に対応する駒がありません"
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
            raise PieceNotFound, "#{arg.inspect} に対応する駒がありません"
          end
        end

        # FIXME: 速くする
        def csa_promoted_fetch(arg)
          case
          when piece = find{|e|e.csa_name1 == arg}
            MiniSoldier[piece: piece]
          when piece = find{|e|e.csa_name2 == arg}
            MiniSoldier[piece: piece, promoted: true]
          else
            raise PieceNotFound, "#{arg.inspect} に対応する駒がありません"
          end
        end

        # 台上の持駒文字列をハッシュ配列化
        #   hold_pieces_s_to_a("飛 香二") # => [{piece: Piece["飛"], count: 1}, {piece: Piece["香"], count: 2}]
        def hold_pieces_s_to_a(*args)
          Utils.hold_pieces_s_to_a(*args)
        end

        private

        def basic_get(arg)
          find do |piece|
            piece.basic_names.include?(arg.to_s)
          end
        end

        def promoted_get(arg)
          find do |piece|
            piece.promoted_names.include?(arg.to_s)
          end
        end
      }
    end

    def inspect
      "<#{self.class.name}:#{object_id} #{name} #{key}>"
    end

    def to_h
      [
        :name,
        :promoted_name,
        :basic_names,
        :promoted_names,
        :names,
        :key,
        :promotable,
        :basic_once_vectors,
        :basic_repeat_vectors,
        :promoted_once_vectors,
        :promoted_repeat_vectors,
      ].inject({}) do |a, e|
        a.merge(e => send(e))
      end
    end

    concerning :NameMethods do
      class_methods do
        def all_names
          @all_names ||= collect(&:names).flatten
        end

        def all_basic_names
          @all_basic_names ||= collect(&:basic_names).flatten
        end
      end

      def some_name(promoted)
        if promoted
          promoted_name
        else
          name
        end
      end

      def some_name2(promoted)
        if promoted
          csa_name2
        else
          csa_name1
        end
      end

      # 名前すべて
      def names
        basic_names + promoted_names
      end

      # 成ってないときの名前たち
      def basic_names
        [name, basic_alias].flatten.compact
      end

      # 成ったときの名前たち
      # 「キーの大文字」を成名としているのはおまけ
      def promoted_names
        [promoted_name, promoted_alias].flatten.compact
      end
    end

    concerning :OtherMethods do
      # 飛角か？
      def brave?
        attributes[:promoted_repeat_vectors]
      end

      # 成れる駒か？
      def promotable?
        !!promotable
      end

      private

      def assert_promotable(promoted)
        if !promotable? && promoted
          raise NotPromotable
        end
      end
    end

    concerning :VectorMethods do
      # ベクトル取得の唯一の外部インタフェース
      def select_vectors(promoted = false)
        assert_promotable(promoted)

        if promoted
          promoted_vectors
        else
          basic_vectors
        end
      end

      private

      # 通常の合成ベクトル
      def basic_vectors
        @basic_vectors ||= build_vectors(basic_once_vectors, basic_repeat_vectors)
      end

      # 成ったときの合成ベクトル
      def promoted_vectors
        @promoted_vectors ||= build_vectors(promoted_once_vectors, promoted_repeat_vectors)
      end

      def build_vectors(ov, rv)
        (ov.compact.collect{|v|OnceVector[*v]} + rv.compact.collect{|v|RepeatVector[*v]}).to_set
      end

      def basic_once_vectors
        __vectors_at(super)
      end

      def basic_repeat_vectors
        __vectors_at(super)
      end

      def promoted_once_vectors
        __vectors_at(super)
      end

      def promoted_repeat_vectors
        __vectors_at(super)
      end

      def __vectors_at(value)
        if value
          if value.kind_of?(Symbol)
            send(value)
          else
            value
          end
        else
          []
        end
      end

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

      def pattern_silver
        [
          [-1, -1], [0, -1], [1, -1],
          nil,          nil,     nil,
          [-1,  1],     nil, [1,  1],
        ]
      end

      def pattern_gold
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ]
      end

      def pattern_king
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],     nil, [1,  0],
          [-1,  1], [0,  1], [1,  1],
        ]
      end
    end
  end
end
