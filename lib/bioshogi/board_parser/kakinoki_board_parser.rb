# frozen-string-literal: true

module Bioshogi
  module BoardParser
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
    class KakinokiBoardParser < Base
      class << self
        def accept?(source)
          source && source.match?(/^\p{blank}*(\+\-*\+|\|.*\|)/)
        end
      end

      def parse
        cell_walker do |place, prefix_char, something|
          if Piece.all_names_set.include?(something)
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
          @h_units = Dimension::DimensionColumn.char_infos.last(count)
        else
          @h_units = s.strip.split # 一行目のX座標の単位取得。全角数字の羅列から推測する。「一 二」なら横幅2と判定できる
        end
      end

      def place_validate(x, y, something)
        unless @h_units[x] && @v_units[y]
          raise SyntaxDefact, "盤面の情報が読み取れません。#{something.inspect} が盤面からはみ出ているかもしれません。左上の升目を (0, 0) としたときの (#{x}, #{y}) の地点です\n#{@source}"
        end
      end

      def prefix_char_validate(x, y, prefix_char)
        unless prefix_char.match?(/[[:ascii:]]/)
          raise SyntaxDefact, "盤面がずれているかもしれません。prefix_char=#{prefix_char.inspect}。左上の升目を (0, 0) としたときの (#{x}, #{y}) の地点です\n#{@source}"
        end
      end

      def cell_walker
        h_units_read

        mds = shape_lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        @v_units = mds.collect.with_index { |v, i| v[:y] || Dimension::DimensionRow.char_infos[i] }
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
  end
end
