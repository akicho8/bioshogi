# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/piece_spec.rb" -*-
# frozen-string-literal: true
#
# 駒
#   Piece["歩"].name  # => "歩"
#   Piece[:pawn].name # => "歩"
#   Piece.each{|piece|...}
#
# 注意点
#   == を定義すると面倒なことになる
#   持駒の歩を取り出すため `player.pieces.delete(Piece["歩"])' としたとき歩が全部消えてしまう
#   同じ種類の駒、同じ種類の別の駒を分けて判別するためには == を定義しない方がいい
#

module Bushido
  class Piece
    include ApplicationMemoryRecord
    memory_record [
      {key: :king,   name: "玉", basic_alias: "王", promoted_name: nil,  promoted_alias: nil,    csa_basic_name: "OU", csa_promoted_name: nil,  sfen_char: "K", promotable: false, basic_weight: 9999, promoted_weight: 0,    mochigoma_weight: 9999},
      {key: :rook,   name: "飛", basic_alias: nil,  promoted_name: "龍", promoted_alias: "竜",   csa_basic_name: "HI", csa_promoted_name: "RY", sfen_char: "R", promotable: true,  basic_weight: 2000, promoted_weight: 2200, mochigoma_weight: 2100},
      {key: :bishop, name: "角", basic_alias: nil,  promoted_name: "馬", promoted_alias: nil,    csa_basic_name: "KA", csa_promoted_name: "UM", sfen_char: "B", promotable: true,  basic_weight: 1800, promoted_weight: 2000, mochigoma_weight: 1890},
      {key: :gold,   name: "金", basic_alias: nil,  promoted_name: nil,  promoted_alias: nil,    csa_basic_name: "KI", csa_promoted_name: nil,  sfen_char: "G", promotable: false, basic_weight: 1200, promoted_weight: 0,    mochigoma_weight: 1260},
      {key: :silver, name: "銀", basic_alias: nil,  promoted_name: "全", promoted_alias: "成銀", csa_basic_name: "GI", csa_promoted_name: "NG", sfen_char: "S", promotable: true,  basic_weight: 1000, promoted_weight: 1200, mochigoma_weight: 1050},
      {key: :knight, name: "桂", basic_alias: nil,  promoted_name: "圭", promoted_alias: "成桂", csa_basic_name: "KE", csa_promoted_name: "NK", sfen_char: "N", promotable: true,  basic_weight:  700, promoted_weight: 1200, mochigoma_weight:  735},
      {key: :lance,  name: "香", basic_alias: nil,  promoted_name: "杏", promoted_alias: "成香", csa_basic_name: "KY", csa_promoted_name: "NY", sfen_char: "L", promotable: true,  basic_weight:  600, promoted_weight: 1200, mochigoma_weight:  630},
      {key: :pawn,   name: "歩", basic_alias: nil,  promoted_name: "と", promoted_alias: nil,    csa_basic_name: "FU", csa_promoted_name: "TO", sfen_char: "P", promotable: true,  basic_weight:  100, promoted_weight: 1200, mochigoma_weight:  105},
    ]

    class << self
      def lookup(value)
        BasicGoup[value] || PromotedGroup[value] || super
      end

      def fetch(value)
        super
      rescue => error
        raise PieceNotFound, "#{value.inspect} に対応する駒がありません\n#{error.message}"
      end

      # 台上の持駒文字列をハッシュ配列化
      #   hold_pieces_s_to_a("飛 香二") # => [{piece: Piece["飛"], count: 1}, {piece: Piece["香"], count: 2}]
      def hold_pieces_s_to_a(*args)
        Utils.hold_pieces_s_to_a(*args)
      end
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

      def any_name(promoted)
        if promoted
          promoted_name
        else
          name
        end
      end

      def csa_some_name(promoted)
        if promoted
          csa_promoted_name
        else
          csa_basic_name
        end
      end

      # 名前すべて
      def names
        basic_names + promoted_names
      end

      # 成ってないときの名前たち
      def basic_names
        [name, basic_alias, csa_basic_name, sfen_char].flatten.compact
      end

      # 成ったときの名前たち
      # 「キーの大文字」を成名としているのはおまけ
      def promoted_names
        [promoted_name, promoted_alias, csa_promoted_name].flatten.compact
      end
    end

    concerning :UsiMethods do
      class_methods do
        def fetch_by_sfen_char(ch)
          fetch(ch.upcase)
        end
      end

      def to_sfen(promoted: false, location: Location[:black])
        s = []
        if promoted
          s << "+"
        end
        s << sfen_char.public_send(location.key == :black ? :upcase : :downcase)
        s.join
      end
    end

    concerning :OtherMethods do
      # 成れる駒か？
      def promotable?
        !!promotable
      end

      def assert_promotable(v)
        if !promotable? && v
          raise NotPromotable, "成れない駒で成ろうとしています : #{piece.inspect}"
        end
      end
    end

    concerning :VectorMethods do
      included do
        delegate :brave?, :select_vectors, :select_vectors2, :to => :piece_vector
      end
      
      def piece_vector
        PieceVector.fetch(key)
      end
    end
    
    BasicGoup = Piece.inject({}) { |a, e| a.merge(e.basic_names.collect { |key| [key, e] }.to_h) }
    PromotedGroup = Piece.inject({}) { |a, e| a.merge(e.promoted_names.collect { |key| [key, e] }.to_h) }
  end
end
