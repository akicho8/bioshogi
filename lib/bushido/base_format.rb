# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-
#
# kif/ki2読み込みの共通処理
#
module Bushido
  module BaseFormat
    class << self
      # source が Pathname ならそのファイルから読み込み、文字列なら何もしない
      #   こういう設計はいまいちな感もあるけど open-uri で open がURLからも読み込むようになるのに似ているからいいとする
      def normalized_source(source)
        if source.kind_of?(Pathname)
          source = source.expand_path.read
        end
        source.to_s.toutf8.gsub(/#{WHITE_SPACE}*\R/, "\n")
      end

      def board_format?(source)
        normalized_source(source).match(/^\s*[\+\|]/)
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
      #   Bushido::BaseFormat.board_parse(str) # => {white: ["４二玉"], black: []}
      #   Bushido::BaseFormat.board_parse(str) # => {white: [<MiniSoldier ...>], black: []}
      #
      def board_parse(source)
        lines = normalized_source(source).strip.lines.to_a

        if lines.empty?
          # board_parse("") の場合
          return {}
        end

        s = lines.first
        if s.match("-")
          if s.count("-").modulo(3).nonzero?
            raise SyntaxError, "横幅が3桁毎になっていない"
          end
          x_units = Position::Hpos.orig_units(zenkaku: true).last(s.gsub("---", "-").count("-"))
        else
          x_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得
        end

        mds = lines.collect{|v|v.match(/\|(?<inline>.*)\|(?<y>.)?/)}.compact
        y_units = mds.collect.with_index{|v, i|v[:y] || Position::Vpos.units(zenkaku: true)[i]}
        inlines = mds.collect{|v|v[:inline]}

        players = Location.inject({}){|h, location|h.merge(location => [])}
        inlines.each_with_index{|s, y| # !> shadowing outer local variable - s
          s.scan(/(.)(\S|\s{2})/).each_with_index{|(prefix, piece), x|
            unless piece == "・" || piece.strip == ""
              unless Piece.all_names.include?(piece)
                raise SyntaxError, "駒の指定が違う : #{piece.inspect}"
              end
              location = Location[prefix] or raise SyntaxError, "「#{str}」の先手後手のマークが違う"
              raise SyntaxError unless x_units[x] && y_units[y]
              point = Point[[x_units[x], y_units[y]].join]
              mini_soldier = Piece.promoted_fetch(piece).merge(point: point)
              players[location] << mini_soldier
            end
          }
        }
        players
      end
    end

    class Parser
      class << self
        def parse(source, options = {})
          new(source, options).tap(&:parse)
        end

        def resolved?(source)
          raise NotImplementedError, "#{__method__} is not implemented"
        end
      end

      attr_reader :header, :move_infos, :first_comments, :source

      def initialize(source, options = {})
        @source = BaseFormat.normalized_source(source)
        @options = default_options.merge(options)

        @header = {}
        @move_infos = []
        @first_comments = []
      end

      def default_options
        {}
      end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      private

      def read_header
        read_key_value
        read_board
      end

      def read_key_value
        @_head.scan(/^(\S.*)：(.*)$/).each { |key, value|
          @header[key] = value
        }
      end

      def read_board
        if md = @_head.match(/^後手の持駒：.*?\n(?<board>.*)^先手の持駒：/m)
          @header[:board_source] = md[:board]
          @header[:board] = BaseFormat.board_parse(md[:board])
        end
      end

      def comment_read(line)
        if md = line.match(/^\s*\*\s*(?<comment>.*)/)
          if @move_infos.empty?
            add_to_first_comments(md[:comment])
          else
            add_to_a_last_move_comments(md[:comment])
          end
        end
      end

      def add_to_first_comments(comment)
        @first_comments << comment
      end

      def add_to_a_last_move_comments(comment)
        @move_infos.last[:comments] ||= []
        @move_infos.last[:comments] << comment
      end
    end

    module Soldier
      def to_s_kakiki
        "#{@player.location.varrow}#{piece_current_name}"
      end
    end

    module Board
      def to_s_kakiki
        KakikiFormat.new(self).to_s
      end

      # kif形式詳細 (1) - 勝手に将棋トピックス http://d.hatena.ne.jp/mozuyama/20030909/p5
      #    ９ ８ ７ ６ ５ ４ ３ ２ １
      #  +---------------------------+
      #  | ・v桂v銀v金v玉v金v銀v桂v香|一
      #  | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      #  |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      #  | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      #  | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      #  | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      #  | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
      #  | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
      #  | 香 桂 銀 金 玉 金 銀 桂 香|九
      #  +---------------------------+
      class KakikiFormat
        def initialize(board)
          @board = board
        end

        def to_s
          [header, line, *rows, line].join("\n") + "\n"
        end

        private

        def header
          "  " + Position::Hpos.units(zenkaku: true).join(" ")
        end

        def line
          "+" + "---" * Position::Hpos.size + "+"
        end

        def rows
          Position::Vpos.size.times.collect do |y|
            fields = Position::Hpos.size.times.collect do |x|
              object_to_s(@board.surface[[x, y]])
            end
            "|#{fields.join}|" + Position::Vpos.parse(y).name
          end
        end

        def object_to_s(object)
          if object
            object.to_s(:kakiki)
          else
            " " + "・"
          end
        end
      end
    end
  end
end
