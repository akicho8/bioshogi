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

module Warabi
  class Piece
    concerning :UtilityMethods do
      class_methods do
        # Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
        def s_to_a(str)
          s_to_h(str).yield_self { |v| h_to_a(v) }
        end

        # Piece.s_to_h("飛0 角 竜1 馬2 龍2") # => {:rook=>3, :bishop=>3}
        def s_to_h(str)
          str = str.tr("〇一二三四五六七八九", "0-9")
          str = str.remove(/\p{blank}/)
          str.scan(/(#{Piece.all_names.join("|")})(\d+)?/o).inject({}) do |a, (piece, count)|
            piece = Piece.fetch(piece)
            a.merge(piece.key => (count || 1).to_i) {|_, v1, v2| v1 + v2 }
          end
        end

        # Piece.h_to_a(rook: 3, "角" => 3, "飛" => 1).collect(&:name) # => ["飛", "飛", "飛", "角", "角", "角", "飛"]
        def h_to_a(hash)
          hash.flat_map do |piece_key, count|
            count.times.collect { Piece.fetch(piece_key) }
          end
        end

        # Piece.a_to_s(["竜", :pawn, "竜"], ordered: true, separator: "/") # => "飛二/歩"
        def a_to_s(pieces, **options)
          options = {
            ordered: false,         # 価値のある駒順に並べる
            separator: " ",
          }.merge(options)

          pieces = pieces.map { |e| Piece.fetch(e) }

          if options[:ordered]
            pieces = pieces.sort_by { |e| -e.basic_weight }
          end

          pieces.group_by(&:key).collect { |key, pieces|
            count = pieces.size
            if count > 1
              count = count.to_s.tr("0-9", "〇一二三四五六七八九")
            else
              count = ""
            end
            "#{pieces.first.name}#{count}"
          }.join(options[:separator])
        end

        # Piece.s_to_a2("▲歩2 飛 △歩二飛 ▲金") # => {:black=>"歩2飛金", :white=>"歩二飛"}
        def s_to_a2(str)
          hash = Location.inject({}) { |a, e| a.merge(e.key => []) }
          str.scan(/([#{Location.triangles_str}])([^#{Location.triangles_str}]+)/) do |triangle, str|
            location = Location[triangle]
            hash[location.key] << str
          end
          hash.transform_values { |e| s_to_a(e.join) }
        end
      end
    end

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
        basic_group[value] || promoted_group[value] || super
      end

      def fetch(value)
        super
      rescue => error
        raise PieceNotFound, "#{value.inspect} に対応する駒がありません\n#{error.message}\nkeys: #{basic_group.keys.inspect}\nkeys: #{promoted_group.keys.inspect}"
      end

      def basic_group
        @basic_group ||= inject({}) { |a, e| a.merge(e.basic_names.collect { |key| [key, e] }.to_h) }
      end

      def promoted_group
        @promoted_group ||= inject({}) { |a, e| a.merge(e.promoted_names.collect { |key| [key, e] }.to_h) }
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
        [name, basic_alias, csa_basic_name, sfen_char, key].flatten.compact
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
      def promotable?
        !!promotable
      end

      def assert_promotable(promoted)
        if !promotable? && promoted
          raise NotPromotable, "#{name}は成れない駒なのに成ろうとしています"
        end
      end
    end

    concerning :VectorMethods do
      included do
        delegate :brave?, :select_vectors, :select_vectors2, to: :piece_vector
      end

      def piece_vector
        PieceVector.fetch(key)
      end
    end
  end
end
