module Bushido
  module Parser
    class BoardParser
      def initialize(source, **options)
        @source = source
        @options = options
      end

      private

      def lines
        @lines ||= Parser.source_normalize(@source).strip.lines.to_a
      end

      def players
        @players ||= Location.inject({}) do |a, location|
          a.merge(location => [])
        end
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
    #   Bushido::Parser.board_parse(str) # => {white: ["４二玉"], black: []}
    #   Bushido::Parser.board_parse(str) # => {white: [<MiniSoldier ...>], black: []}
    #
    class KixBoardParser < BoardParser
      # 盤面テキストか？
      # private にしていないのは他のクラスでも直接使っているため
      def self.board_format?(source)
        Parser.source_normalize(source).match?(/^\p{blank}*[\+\|]/)
      end

      def parse
        cell_width = 3

        if lines.empty?
          # board_parse("") の場合
          return {}
        end

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
          s.scan(/(.)(\S|\s{2})/).each_with_index do |(prefix, piece), x|
            unless piece == "・" || piece.strip == ""
              unless Piece.all_names.include?(piece)
                raise SyntaxDefact, "駒の指定が違います : #{piece.inspect}"
              end
              location = Location[prefix] or raise SyntaxDefact, "先手後手のマークが違います : #{prefix}"
              raise SyntaxDefact unless x_units[x] && y_units[y]
              point = Point[[x_units[x], y_units[y]].join]
              mini_soldier = Piece.promoted_fetch(piece).merge(point: point)
              players[location] << mini_soldier
            end
          end
        end
        players
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
    class CsaBoardParser < BoardParser
      def self.board_format?(source)
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
                mini_soldier = Piece.csa_promoted_fetch(md[:piece]).merge(point: point)
                players[location] << mini_soldier
              end
            end
          end
        end
        players
      end
    end
  end
end
