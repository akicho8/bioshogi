# frozen-string-literal: true

module Bushido
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
        [KifBoardParser, CsaBoardParser]
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

      # Location ごちゃまぜの MiniSoldier の配列
      def mini_soldiers
        @mini_soldiers ||= []
      end

      # {Location[:black] => [<MiniSoldier>], Location[:white] => [...]}
      def both_board_info
        @both_board_info ||= __both_board_info
      end

      # def side_board_info_by(location)
      #   both_board_info[location] || []
      # end

      # def black_side_mini_soldiers
      #   both_board_info[Location[:black]] || []
      # end

      private

      def __both_board_info
        v = mini_soldiers.group_by { |e| e[:location] }
        Location.each { |e| v[e] ||= [] } # FIXME: これはダサい
        v
      end

      def shape_lines
        @shape_lines ||= Parser.source_normalize(@source).strip.lines.to_a
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
        cell_walker do |point, location, something|
          if Piece.all_names.include?(something)
            mini_soldiers << MiniSoldier.new_with_promoted(something).merge(point: point, location: location)
          else
            betsunomonoga_mitsukatta(point, location, something)
          end
        end
      end

      private

      def cell_width
        3
      end

      def x_units_read
        s = shape_lines.first
        if s.include?("-")
          if s.count("-").modulo(cell_width).nonzero?
            raise SyntaxDefact, "横幅が#{cell_width}桁毎になっていません"
          end
          count = s.gsub("---", "-").count("-")
          @x_units = Position::Hpos.units.last(count)
        else
          @x_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得
        end
      end

      def xy_validation(x, y, something)
        unless @x_units[x] && @y_units[y]
          raise SyntaxDefact, "盤面の情報が読み取れません。#{something.inspect} が盤面からはみ出ている可能性があります。左上の升目を (0, 0) としたときの (#{x}, #{-y}) の地点です\n#{@source}"
        end
      end

      def betsunomonoga_mitsukatta(*)
      end

      def cell_walker
        x_units_read

        mds = shape_lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        @y_units = mds.collect.with_index { |v, i| v[:y] || Position::Vpos.units[i] }
        inlines = mds.collect { |v| v[:inline] }

        inlines.each.with_index do |s, y|
          # 1文字 + (全角1文字 or 半角2文字)
          s.scan(/(.)([[:^ascii:]]|[[:ascii:]]{2})/).each.with_index do |(location_mark, something), x|
            xy_validation(x, y, something)
            point = Point[[@x_units[x], @y_units[y]].join]
            location = Location.fetch(location_mark)
            yield point, location, something
          end
        end
      end
    end

    class KifBoardParser2 < KifBoardParser
      def other_objects
        @other_objects ||= []
      end

      def betsunomonoga_mitsukatta(point, location, something)
        unless something == "・"
          other_objects << {point: point, location: location, something: something}
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
        shape_lines.each do |line|
          if md = line.match(/P(?<y>\d+)(?<cells>.*)/)
            y = md[:y]
            # 空白または * の文字を 1..3 とすることで行末スペースの有無に依存しなくなる
            cells = md[:cells].scan(/\S{3}|[\s\*]{1,3}/)
            cells.reverse_each.with_index(1) do |e, x|
              if md = e.match(/(?<csa_sign>\S)(?<piece>\S{2})/)
                location = Location[md[:csa_sign]]
                point = Point["#{x}#{y}"]
                mini_soldiers << MiniSoldier.csa_new_with_promoted(md[:piece]).merge(point: point, location: location)
              end
            end
          end
        end
      end
    end
  end
end
