# frozen-string-literal: true

module Bioshogi
  module BoardParser
    class << self
      def accept?(source)
        !!parser_class_for(source)
      end

      def parse(source, **options)
        parser = parser_class_for(source)
        unless parser
          raise FileFormatError, "盤面のフォーマットが不明です : #{source}"
        end
        parser.parse(source, options)
      end

      private

      def parser_class_for(source)
        support_parsers.find {|e| e.accept?(source) }
      end

      def support_parsers
        [
          KifBoardParser,
          CsaBoardParser,
          SfenBoardParser,
        ]
      end
    end

    class Base
      class << self
        def accept?
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def parse(source, **options)
          new(source, options).tap(&:parse)
        end
      end

      def initialize(source, **options)
        @source = source
        @options = options
      end

      delegate *[
        :sorted_soldiers,
        :location_split,
        :place_as_key_table,
        :location_adjust,
      ], to: :soldiers

      def soldiers
        soldier_box
      end

      def soldier_box
        @soldier_box ||= SoldierBox.new
      end

      private

      def shape_lines
        @shape_lines ||= Parser.source_normalize(@source).remove(/\s*#.*/).strip.lines.to_a
      end
    end

    # ほぼ標準の柿木フォーマットのテーブルの読み取り
    #
    # @example
    #   str = "
    #     ９ ８ ７ ６ ５ ４ ３ ２ １
    #   +---------------------------+
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
    #   | ・ ・ ・ ・ ・v玉 ・ ・ ・|二
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
    #   | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
    #   +---------------------------+
    #   "
    #
    #   Bioshogi::BoardParser.parse(str) # => {white: ["４二玉"], black: []}
    #   Bioshogi::BoardParser.parse(str) # => {white: [<Soldier ...>], black: []}
    #
    class KifBoardParser < Base
      class << self
        def accept?(source)
          source && source.match?(/^\p{blank}*[\+\|]/)
        end
      end

      def parse
        cell_walker do |place, prefix_char, something|
          if Piece.all_names.include?(something)
            soldiers << build(place, something, prefix_char)
          end
        end
      end

      private

      def cell_width
        3
      end

      def h_units_read
        s = shape_lines.first
        if s.include?("-")
          if s.count("-").modulo(cell_width).nonzero?
            raise SyntaxDefact, "最初の行の横幅が#{cell_width}桁毎になっていません\n#{@source}"
          end
          count = s.gsub("---", "-").count("-")
          @h_units = Dimension::Xplace.units.last(count)
        else
          @h_units = s.strip.split # 一行目のX座標の単位取得。全角数字の羅列から推測する。「一 二」なら横幅2と判定できる
        end
      end

      def place_validate(x, y, something)
        unless @h_units[x] && @v_units[y]
          raise SyntaxDefact, "盤面の情報が読み取れません。#{something.inspect} が盤面からはみ出ている可能性があります。左上の升目を (0, 0) としたときの (#{x}, #{y}) の地点です\n#{@source}"
        end
      end

      def prefix_char_validate(x, y, prefix_char)
        unless prefix_char.match?(/[[:ascii:]]/)
          raise SyntaxDefact, "盤面がずれている可能性があります。prefix_char=#{prefix_char.inspect}。左上の升目を (0, 0) としたときの (#{x}, #{y}) の地点です\n#{@source}"
        end
      end

      def cell_walker
        h_units_read

        mds = shape_lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        @v_units = mds.collect.with_index { |v, i| v[:y] || Dimension::Yplace.units[i] }
        inlines = mds.collect { |v| v[:inline] }

        inlines.each.with_index do |s, y|
          # 1文字 + (全角1文字 or 半角2文字)
          s.scan(/(.)([[:^ascii:]]|[[:ascii:]]{2})/).each.with_index do |(prefix_char, something), x|
            prefix_char_validate(x, y, prefix_char)
            place_validate(x, y, something)
            place = Place[[@h_units[x], @v_units[y]].join]
            yield place, prefix_char, something
          end
        end
      end

      def build(place, piece, location_key)
        Soldier.new_with_promoted(piece, place: place, location: Location.fetch(location_key))
      end
    end

    class FireBoardParser < KifBoardParser
      def parse
        cell_walker do |place, prefix_char, something|
          case
          when Piece.all_names.include?(something)
            case prefix_char
            when "!"
              # トリガーとする。盤面には含めない(含める必要がないため)
              soldier = build(place, something, :black)
              trigger_soldiers << soldier
            when "@"
              # ! と同じだけど、盤面情報に含める(複数トリガーを書くとき用)
              soldier = build(place, something, :black)
              trigger_soldiers << soldier
              soldiers << soldier # 盤面の駒とする
            when "?"
              # △側でどれかがここに含まれる
              soldier = build(place, something, :white)
              any_exist_soldiers << soldier
            when "*"
              # ▲でどれかがここに含まれる
              soldier = build(place, something, :black)
              any_exist_soldiers << soldier
            else
              soldier = build(place, something, prefix_char)
              soldiers << soldier
            end
          when something != "・"
            other_objects << {place: place, prefix_char: prefix_char, something: something}
          end
        end
      end

      def other_objects
        @other_objects ||= []
      end

      def trigger_soldiers
        @trigger_soldiers ||= SoldierBox.new
      end

      def any_exist_soldiers
        @any_exist_soldiers ||= SoldierBox.new
      end

      # 高速に比較するためにメモ化したアクセサシリーズ

      # something のグループ化
      def other_objects_hash_ary
        @other_objects_hash_ary ||= other_objects.group_by { |e| e[:something] }
      end

      # something のグループ化 + place 毎のハッシュ
      def other_objects_hash
        @other_objects_hash ||= other_objects_hash_ary.transform_values { |v| v.inject({}) { |a, e| a.merge(e[:place] => e) } }
      end

      # other_objects_hash_ary + 末尾配列
      def other_objects_loc_ary
        @other_objects_loc_ary ||= Location.inject({}) do |a, l|
          hash = other_objects_hash_ary.transform_values { |v|
            v.collect { |e| e.merge(place: e[:place].public_send(l.normalize_key)) }
          }
          a.merge(l.key => hash)
        end
      end

      # other_objects_hash_ary + 末尾 place のハッシュ
      def other_objects_loc_places_hash
        @other_objects_loc_places_hash ||= Location.inject({}) do |a, l|
          places_hash = other_objects_hash_ary.transform_values do |v|
            v.inject({}) { |a, e|
              e = e.merge(:place => e[:place].public_send(l.normalize_key))
              a.merge(e[:place] => e)
            }
          end
          a.merge(l.key => places_hash)
        end
      end

      # テーブルのキーとする駒すべて
      # プライマリー駒があると絞れるのでなるべく付けたい
      # プライマリー駒がないと、他すべてをプライマリー駒と見なす
      def primary_soldiers
        @primary_soldiers ||= Array(trigger_soldiers.presence || soldiers.presence)
      end
    end

    # P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
    # P2 * -HI *  *  *  *  * -KA *
    # P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
    # P4 *  *  *  *  *  *  *  *  *
    # P5 *  *  *  *  *  *  *  *  *
    # P6 *  *  *  *  *  *  *  *  *
    # P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
    # P8 * +KA *  *  *  *  * +HI *
    # P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
    class CsaBoardParser < Base
      def self.accept?(source)
        source && source.match?(/\b(P\d+)\b/)
      end

      def parse
        shape_lines.each do |line|
          if md = line.match(/P(?<y>\d+)(?<cells>.*)/)
            y = md[:y]
            # 空白または * の文字を 1..3 とすることで行末スペースの有無に依存しなくなる
            cells = md[:cells].scan(/\S{3}|[\s\*]{1,3}/)
            cells.reverse_each.with_index(1) do |e, x|
              if md = e.match(/(?<csa_sign>\S)(?<piece>\S{2})/)
                location = Location[md[:csa_sign]]
                place = Place["#{x}#{y}"]
                soldiers << Soldier.new_with_promoted(md[:piece], place: place, location: location)
              end
            end
          end
        end
      end
    end

    class SfenBoardParser < Base
      def self.accept?(source)
        source && source.include?("/")
      end

      def parse
        @source.split("/").each.with_index do |row, y|
          x = 0
          row.scan(/(\+?)(.)/) do |promoted, ch|
            place = Place.fetch([x, y])
            if ch.match?(/\d+/)
              x += ch.to_i
            else
              location = Location.fetch_by_sfen_char(ch)
              promoted = (promoted == "+")
              piece = Piece.fetch_by_sfen_char(ch)
              soldiers << Soldier.create(piece: piece, place: place, location: location, promoted: promoted)
              x += 1
            end
          end
        end
      end
    end
  end
end
