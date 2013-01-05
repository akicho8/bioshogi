# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module BaseFormat
    class Parser
      def self.parse(source, options = {})
        new(source, options).tap{|o|o.parse}
      end

      def self.resolved?(source)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def self.normalized_source(source)
        if source.kind_of? Pathname
          source = source.expand_path.read
        end
        source.to_s.toutf8.gsub(/[#{[0x3000].pack('U')} ]*\r?\n/, "\n")
      end

      # 柿木フォーマットのテーブル
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
      #   board_parse(str) # => {:white=>{:soldiers=>["４二玉"]}, :black=>{:soldiers=>[]}}
      #
      def self.board_parse(source)
        str = normalized_source(source)
        lines = str.strip.lines.to_a
        x_units = lines.first.strip.split(/\s+/)                   # 一行目のX座標の単位取得
        lines = lines.find_all{|line|line.start_with?("|")}
        y_units = lines.collect{|line|line.match(/(?<y>.)\n/)[:y]}
        lines = lines.collect{|line|line.match(/\|(?<content>.*)\|/)[:content]}

        players = {}
        players[:white] = {}
        players[:black] = {}

        lines.each_with_index{|line, y_index|
          line.scan(/(.)(\S)/).each_with_index{|(prefix, piece), x_index|
            player = players[prefix == " " ? :black : :white]
            player[:soldiers] ||= []
            if piece == "・"
            else
              player[:soldiers] << [x_units[x_index], y_units[y_index], piece].join
            end
          }
        }
        players
      end

      attr_reader :header, :move_infos, :first_comments, :source

      def initialize(source, options = {})
        @source = self.class.normalized_source(source)
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
        @_head.scan(/^(\S.*)：(.*)$/).each{|key, value|
          @header[key] = value
        }
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
        "#{@player.location == :white ? 'v' : ' '}#{piece_current_name}"
      end
    end

    module Board
      # kif形式詳細 (1) - 勝手に将棋トピックス http://d.hatena.ne.jp/mozuyama/20030909/p5
      #
      #   ９ ８ ７ ６ ５ ４ ３ ２ １
      # +---------------------------+
      # | ・v桂v銀v金v玉v金v銀v桂v香|一
      # | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      # |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      # | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
      # | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
      # | 香 桂 銀 金 玉 金 銀 桂 香|九
      # +---------------------------+
      def to_s_kakiki
        rows = Position::Vpos.units.size.times.collect{|y|
          values = Position::Hpos.units.size.times.collect{|x|
            if soldier = @matrix[[x, y]]
              soldier.to_s(:kakiki)
            else
              " " + "・"
            end
          }
          "|" + values.join + "|" + Position::Vpos.parse(y).name
        }
        s = []
        s << "  " + Position::Hpos.zenkaku_units.join(" ")
        hline = "+" + "---" * Position::Hpos.zenkaku_units.size + "+"
        s << hline
        s += rows
        s << hline
        s.collect{|e|e + "\n"}.join
      end
    end
  end
end
