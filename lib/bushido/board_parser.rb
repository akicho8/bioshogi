# frozen-string-literal: true

module Bushido
  module BoardParser
    class << self
      def accept?(source)
        !!parser_class_for(source)
      end

      def parse(source, **options)
        parser = parser_class_for(source)
        parser or raise FileFormatError, "盤面のフォーマットが不明です : #{source}"
        parser.parse(source, options)
      end

      private

      def parser_class_for(source)
        support_parsers.find {|e| e.accept?(source) }
      end

      def support_parsers
        [KifBoardParser, CsaBoardParser]
      end
    end

    class Base
      class << self
        def accept?
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def parse(source, options)
          new(source, options).tap(&:parse)
        end
      end

      def initialize(source, **options)
        @source = source
        @options = options
      end

      def mini_soldiers
        @mini_soldiers ||= []
      end

      def both_board_info
        @both_board_info ||= __both_board_info
      end

      def side_board_info_by(location)
        both_board_info[location] || []
      end

      def black_side_mini_soldiers
        both_board_info[Location[:black]] || []
      end

      private

      def __both_board_info
        v = mini_soldiers.group_by { |e| e[:location] }
        Location.each { |e| v[e] ||= [] }
        v
      end

      def lines
        @lines ||= Parser.source_normalize(@source).strip.lines.to_a
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
    #   Bushido::BoardParser.parse(str) # => {white: ["４二玉"], black: []}
    #   Bushido::BoardParser.parse(str) # => {white: [<MiniSoldier ...>], black: []}
    #
    class KifBoardParser < Base
      class << self
        # 盤面テキストか？
        # private にしていないのは他のクラスでも直接使っているため
        def accept?(source)
          Parser.source_normalize(source).match?(/^\p{blank}*[\+\|]/)
        end
      end

      def parse
        cell_width = 3

        s = lines.first
        if s.include?("-")
          if s.count("-").modulo(cell_width).nonzero?
            raise SyntaxDefact, "横幅が#{cell_width}桁毎になっていません"
          end
          count = s.gsub("---", "-").count("-")
          x_units = Position::Hpos.units.last(count)
        else
          x_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得
        end

        mds = lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        y_units = mds.collect.with_index { |v, i| v[:y] || Position::Vpos.units[i] }
        inlines = mds.collect { |v| v[:inline] }

        inlines.each.with_index do |s, y|
          # 1文字 + (全角1文字 or 半角2文字)
          s.scan(/(.)([[:^ascii:]]|[[:ascii:]]{2})/).each_with_index do |(location_char, piece), x|
            if Piece.all_names.include?(piece)
              raise SyntaxDefact unless x_units[x] && y_units[y]
              point = Point[[x_units[x], y_units[y]].join]
              location = Location.fetch(location_char)
              mini_soldiers << Piece.promoted_fetch(piece).merge(point: point, location: location)
            end
          end
        end
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
        Parser.source_normalize(source).match?(/^P\d+/)
      end

      def parse
        lines.each do |line|
          if md = line.match(/P(?<y>\d+)(?<cells>.*)/)
            y = md[:y]
            # 空白または * の文字を 1..3 とすることで行末のスペースが消えても問題なくなる
            cells = md[:cells].scan(/\S{3}|[\s\*]{1,3}/)
            cells.reverse_each.with_index(1) do |e, x|
              if md = e.match(/(?<mark>\S)(?<piece>\S{2})/)
                location = Location[md[:mark]]
                point = Point["#{x}#{y}"]
                mini_soldiers << Piece.csa_promoted_fetch(md[:piece]).merge(point: point, location: location)
              end
            end
          end
        end
      end
    end
  end
end
