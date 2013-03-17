# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-
#
# kif/ki2読み込みの共通処理
#
module Bushido
  module BaseFormat
    # source が Pathname ならそのファイルから読み込み、文字列なら何もしない
    #   こういう設計はいまいちな感もあるけど open-uri で open がURLからも読み込むようになるのに似ているからいいとする
    def self.normalized_source(source)
      if Pathname === source
        source = source.expand_path.read
      end
      source.to_s.toutf8.gsub(/#{WHITE_SPACE}*\r?\n/, "\n")
    end

    def self.board_string?(source)
      BaseFormat.normalized_source(source).match(/^[\+\|]/)
    end

    # ほぼ標準の柿木フォーマットのテーブルの読み取り
    #
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
    #   Bushido::BaseFormat.board_parse(str) # => {:white => ["４二玉"], :black => []}
    #
    def self.board_parse(source)
      str = BaseFormat.normalized_source(source)
      lines = str.strip.lines.to_a

      s = lines.first
      if s.match("-")
        if s.count("-").modulo(3).nonzero?
          raise SyntaxError, "横幅が3桁毎になっていない"
        end
        x_units = Position::Hpos.units(:zenkaku => true).last(s.gsub("---", "-").count("-"))
      else
        x_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得
      end

      mds = lines.collect{|v|v.match(/\|(?<inline>.*)\|(?<y>.)?/)}.compact
      y_units = mds.collect.with_index{|v, i|v[:y] || Position::Vpos.units(:zenkaku => true)[i]}
      inlines = mds.collect{|v|v[:inline]}

      players = Location.inject({}){|h, location|h.merge(location.key => [])}
      inlines.each_with_index{|s, y|
        s.scan(/(.)(\S|\s{2})/).each_with_index{|(prefix, piece), x|
          unless piece == "・" || piece.strip == ""
            unless Piece.names.include?(piece)
              raise SyntaxError, "駒の指定が違う : #{piece.inspect}"
            end
            location = Location[prefix] or raise SyntaxError, "「#{str}」の先手後手のマークが違う"
            players[location.key] << [x_units[x], y_units[y], piece].join
          end
        }
      }
      players
    end

    class Parser
      def self.parse(source, options = {})
        new(source, options).tap{|o|o.parse}
      end

      def self.resolved?(source)
        raise NotImplementedError, "#{__method__} is not implemented"
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
        @_head.scan(/^(\S.*)：(.*)$/).each{|key, value|
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
      def to_s_kakiki
        rows = Position::Vpos.ridge_length.times.collect{|y|
          values = Position::Hpos.ridge_length.times.collect{|x|
            if soldier = @surface[[x, y]]
              soldier.to_s(:kakiki)
            else
              " " + "・"
            end
          }
          "|" + values.join + "|" + Position::Vpos.parse(y).name
        }
        s = []
        s << "  " + Position::Hpos.units(:zenkaku => true).join(" ")
        hline = "+" + "---" * Position::Hpos.ridge_length + "+"
        s << hline
        s += rows
        s << hline
        s.collect{|e|e + "\n"}.join
      end
    end
  end
end
