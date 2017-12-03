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

      # Location ごちゃまぜの Soldier の配列 (FIXME: 全部、ハッシュの配列しておいてあとで分解するほうがよいか？)
      def soldiers
        @soldiers ||= []
      end

      def sorted_soldiers
        @sorted_soldiers ||= soldiers.sort
      end

      # {Location[:black] => [<Soldier>], Location[:white] => [...]}
      def both_board_info
        @both_board_info ||= __both_board_info
      end

      # def side_board_info_by(location)
      #   both_board_info[location] || []
      # end

      # def black_side_soldiers
      #   both_board_info[Location[:black]] || []
      # end

      private

      def __both_board_info
        v = soldiers.group_by { |e| e[:location] }
        Location.each { |e| v[e] ||= [] } # FIXME: これはダサすぎないか？
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
    #   Bushido::BoardParser.parse(str) # => {white: [<Soldier ...>], black: []}
    #
    class KifBoardParser < Base
      class << self
        def accept?(source)
          Parser.source_normalize(source).match?(/^\p{blank}*[\+\|]/)
        end
      end

      def parse
        cell_walker do |point, prefix_char, something|
          if Piece.all_names.include?(something)
            soldiers << soldiers_create(point, something, prefix_char)
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
          @h_units = Position::Hpos.units.last(count)
        else
          @h_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得。全角数字の羅列から推測する。「一 二」なら横幅2と判定できる
        end
      end

      def point_validate(x, y, something)
        unless @h_units[x] && @v_units[y]
          raise SyntaxDefact, "盤面の情報が読み取れません。#{something.inspect} が盤面からはみ出ている可能性があります。左上の升目を (0, 0) としたときの (#{x}, #{-y}) の地点です\n#{@source}"
        end
      end

      def cell_walker
        h_units_read

        mds = shape_lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        @v_units = mds.collect.with_index { |v, i| v[:y] || Position::Vpos.units[i] }
        inlines = mds.collect { |v| v[:inline] }

        inlines.each.with_index do |s, y|
          # 1文字 + (全角1文字 or 半角2文字)
          s.scan(/(.)([[:^ascii:]]|[[:ascii:]]{2})/).each.with_index do |(prefix_char, something), x|
            point_validate(x, y, something)
            point = Point[[@h_units[x], @v_units[y]].join]
            yield point, prefix_char, something
          end
        end
      end

      def soldiers_create(point, piece, prefix_char)
        Soldier.new_with_promoted(piece).merge(point: point, location: Location.fetch(prefix_char))
      end
    end

    class FireBoardParser < KifBoardParser
      def parse
        cell_walker do |point, prefix_char, something|
          case
          when Piece.all_names.include?(something)
            # if prefix_char == "!"
            #   location = " "
            # else
            #   location = prefix_char
            # end
            # soldier = soldiers_create(point, something, location)
            # soldiers << soldier
            # if prefix_char == "!"
            #   trigger_soldiers << soldier
            # end

            case prefix_char
            when "!"
              soldier = soldiers_create(point, something, :black)
              trigger_soldiers << soldier
            when "@"
              soldier = soldiers_create(point, something, :black)
              trigger_soldiers << soldier
              soldiers << soldier # 盤面の駒とする
            else
              soldier = soldiers_create(point, something, prefix_char)
              soldiers << soldier
            end
          when something != "・"
            other_objects << {point: point, location: location, something: something}
          end
        end
      end

      def other_objects
        @other_objects ||= []
      end

      def trigger_soldiers
        @trigger_soldiers ||= []
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
                soldiers << Soldier.csa_new_with_promoted(md[:piece]).merge(point: point, location: location)
              end
            end
          end
        end
      end
    end
  end
end
