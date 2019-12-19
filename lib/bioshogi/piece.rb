# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/piece_spec.rb" -*-
# frozen-string-literal: true

require "bioshogi/piece/piece_csa"
require "bioshogi/piece/piece_vector"
require "bioshogi/piece/piece_score"
require "bioshogi/piece/piece_yomiage"
require "bioshogi/piece/piece_pressure"

module Bioshogi
  class Piece
    class << self
      # Piece.s_to_h("飛0 角 竜1 馬2 龍2")                    # => {:rook=>3, :bishop=>3}
      # Piece.h_to_a(rook: 2, bishop: 1).collect(&:name)      # => ["飛", "飛", "角"]
      # Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
      # Piece.a_to_s([:bishop, "竜", "竜"])                   # => "飛二 角"
      # Piece.s_to_h2("▲歩2 飛 △歩二飛 ▲金")               # => {:black=>{:pawn=>2, :rook=>1, :gold=>1}, :white=>{:pawn=>2, :rook=>1}}
      # Piece.h_to_s(bishop: 1, rook: 2)                      # => "飛二 角"

      # Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
      def s_to_a(str)
        s_to_h(str).yield_self { |v| h_to_a(v) }
      end

      # Piece.s_to_h("飛0 角 竜1 馬2 龍2") # => {:rook=>3, :bishop=>3}
      def s_to_h(str)
        str = KanjiNumber.kanji_to_number_string(str)
        str = str.remove(/\p{blank}/)
        str.scan(/(#{Piece.all_names.join("|")})(\d+)?/o).inject({}) do |a, (piece, count)|
          piece = Piece.fetch(piece)
          a.merge(piece.key => (count || 1).to_i) {|_, v1, v2| v1 + v2 }
        end
      end

      # Piece.h_to_a(rook: 2, bishop: 1).collect(&:name)      # => ["飛", "飛", "角"]
      def h_to_a(hash)
        hash.flat_map do |piece_key, count|
          count.times.collect { Piece.fetch(piece_key) }
        end
      end

      # Piece.h_to_s(bishop: 1, rook: 2) # => "飛二 角"
      def h_to_s(hash, **options)
        options = {
          ordered: true,      # 価値のある駒順に並べる
          separator: " ",
        }.merge(options)

        hash = hash.collect { |piece_key, count| [Piece.fetch(piece_key), count] }

        if options[:ordered]
          hash = hash.sort_by { |piece, _| -piece.basic_weight }
        end

        hash.map { |piece, count|
          raise MustNotHappen if count < 0
          if count >= 2
            count = KanjiNumber.integer_to_kanji(count)
          else
            count = ""
          end
          "#{piece.name}#{count}"
        }.join(options[:separator])
      end

      # Piece.a_to_s(["竜", :pawn, "竜"], ordered: true, separator: "/") # => "飛二/歩"
      def a_to_s(pieces, **options)
        pieces = pieces.collect { |e| Piece.fetch(e) }
        h_to_s(pieces.group_by(&:key).transform_values(&:size), options)
      end

      # Piece.s_to_h2("▲歩2 飛 △歩二飛 ▲金") # => {:black=>{:pawn=>2, :rook=>1, :gold=>1}, :white=>{:pawn=>2, :rook=>1}}
      def s_to_h2(str)
        hash = Location.inject({}) { |a, e| a.merge(e.key => []) }
        str.scan(/([#{Location.triangles_str}])([^#{Location.triangles_str}]+)/) do |triangle, str|
          location = Location[triangle]
          hash[location.key] << str
        end
        hash.transform_values { |e| s_to_h(e.join) }
      end
    end

    include ApplicationMemoryRecord
    memory_record [
      { key: :king,   name: "玉", basic_alias: "王", promoted_name: nil,  promoted_formal_sheet_name: nil,    other_matched_promoted_names: nil,   sfen_char: "K", promotable: false, always_alive: true,  stronger: false, },
      { key: :rook,   name: "飛", basic_alias: nil,  promoted_name: "龍", promoted_formal_sheet_name: nil,    other_matched_promoted_names: "竜",  sfen_char: "R", promotable: true,  always_alive: true,  stronger: true,  },
      { key: :bishop, name: "角", basic_alias: nil,  promoted_name: "馬", promoted_formal_sheet_name: nil,    other_matched_promoted_names: nil,   sfen_char: "B", promotable: true,  always_alive: true,  stronger: true,  },
      { key: :gold,   name: "金", basic_alias: nil,  promoted_name: nil,  promoted_formal_sheet_name: nil,    other_matched_promoted_names: nil,   sfen_char: "G", promotable: false, always_alive: true,  stronger: false, },
      { key: :silver, name: "銀", basic_alias: nil,  promoted_name: "全", promoted_formal_sheet_name: "成銀", other_matched_promoted_names: nil,   sfen_char: "S", promotable: true,  always_alive: true,  stronger: false, },
      { key: :knight, name: "桂", basic_alias: nil,  promoted_name: "圭", promoted_formal_sheet_name: "成桂", other_matched_promoted_names: "今",  sfen_char: "N", promotable: true,  always_alive: false, stronger: false, },
      { key: :lance,  name: "香", basic_alias: nil,  promoted_name: "杏", promoted_formal_sheet_name: "成香", other_matched_promoted_names: "仝",  sfen_char: "L", promotable: true,  always_alive: false, stronger: false, },
      { key: :pawn,   name: "歩", basic_alias: nil,  promoted_name: "と", promoted_formal_sheet_name: nil,    other_matched_promoted_names: nil,   sfen_char: "P", promotable: true,  always_alive: false, stronger: false, },
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
      attributes
    end

    concerning :NameMethods do
      class_methods do
        def all_names
          @all_names ||= flat_map(&:names)
        end

        def all_basic_names
          @all_basic_names ||= flat_map(&:basic_names)
        end
      end

      def any_name(promoted, **options)
        if promoted
          if options[:char_type] == :formal_sheet
            promoted_formal_sheet_name || promoted_name
          else
            promoted_name
          end
        else
          name
        end
      end

      def names
        basic_names + promoted_names
      end

      def basic_names
        [name, basic_alias, csa.basic_name, sfen_char, key].flatten.compact
      end

      def promoted_names
        [promoted_name, *promoted_formal_sheet_name, *other_matched_promoted_names, csa.promoted_name].flatten.compact
      end
    end

    concerning :UsiMethods do
      class_methods do
        def fetch_by_sfen_char(ch)
          fetch(ch.upcase)
        end
      end

      def to_sfen(promoted: false, location: :black)
        [
          promoted ? "+" : nil,
          sfen_char.public_send(Location[location].key == :black ? :upcase : :downcase),
        ].join
      end
    end

    concerning :CsaMethods do
      def csa
        @csa ||= PieceCsa[key]
      end
    end

    concerning :OtherMethods do
      def promotable?
        promotable
      end
    end

    concerning :VectorMethods do
      included do
        delegate :brave?, :all_vectors, to: :piece_vector
      end

      def piece_vector
        @piece_vector ||= PieceVector[key]
      end
    end

    concerning :ScoreMethods do
      included do
        delegate :any_weight, :basic_weight, :promoted_weight, :hold_weight, to: :piece_score
      end

      def piece_score
        @piece_score ||= PieceScore[key]
      end
    end

    concerning :PressureMethods do
      included do
        delegate :attack_level, :promoted_attack_level, :defense_level, :promoted_defense_level, :standby_level, to: :piece_pressure
      end

      def piece_pressure
        @piece_pressure ||= PiecePressure[key]
      end
    end

    concerning :KifuyomiMethods do
      included do
        delegate :yomiage, to: :piece_yomiage
      end

      def piece_yomiage
        @piece_yomiage ||= YomiagePieceInfo[key]
      end
    end
  end
end
