# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module KifFormat
    class Parser
      def self.parse(source, options = {})
        new(source, options).tap{|o|o.parse}
      end

      attr_reader :header, :move_infos

      def initialize(source, options = {})
        @source = source
        @options = default_options.merge(options)

        @source = normalized_source
      end

      def default_options
        {}
      end

      # # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # 開始日時：1968/03/18
      # 棋戦：順位戦
      # 戦型：中飛車
      # 手合割：平手
      # 先手：加藤博二
      # 後手：松田茂役
      # 手数----指手---------消費時間--
      # *棋戦詳細：第22期順位戦A級
      #    1 ７六歩(77)   ( 0:00/00:00:00)
      def parse
        @header = {}

        if false
          @source.scan(/^(\S.*)：(.*)$/).each{|key, value|
            next if key.match(/^\*/)
            @header[key] = value
          }

          r = @source.scan(/^\s+(\d+)\s+(\S.*?)\s+\(\s*(.*)\)/)
          @move_infos = r.collect{|index, input, spent_time|
            {index: index, input: input, spent_time: spent_time}
          }
        else
          @header = {}
          @move_infos = []
          @start_comments = []

          @current_part = :header
          @source.lines.each do |line|
            if line.match(/^#/)
              next
            end
            if @current_part == :header
              if line.match(/^手数.*指手/)
                @current_part = :body
                next
              end
              if md = line.match(/^(?<key>.*)：(?<value>.*)/)
                @header.update(md[:key] => md[:value])
              end
            end
            if @current_part == :body
              if md = line.match(/^\s*\*\s*(?<comment>.*)/)
                if @move_infos.empty?
                  # 1手目より前にコメントがある場合、結び付く手が無い→つまり開始前メッセージということになる
                  @start_comments << md[:comment]
                else
                  # 手に結び付いているコメント
                  @move_infos.last[:comments] << md[:comment]
                end
              end
              if md = line.match(/^\s+(?<index>\d+)\s+(?<input>\S.*?)\s+\(\s*(?<spent_time>.*)\)/)
                @move_infos << {:index => md[:index], :input => md[:input], :spent_time => md[:spent_time], :comments => []}
              end
            end
          end
        end
      end

      private

      def normalized_source
        if @source.kind_of? Pathname
          @source = @source.expand_path.read
        end
        str = @source.toutf8
        str = str.gsub(/[#{[0x3000].pack('U')}\s]+\r?\n/, "\n")
      end
    end

    module Soldier
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
      end

      def to_kif_name
        "#{@player.location == :white ? 'v' : ' '}#{piece_current_name}"
      end
    end

    module Board
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods
      end

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
      def to_kif_table
        rows = Position::Vpos.units.size.times.collect{|y|
          values = Position::Hpos.units.size.times.collect{|x|
            if soldier = @matrix[[x, y]]
              soldier.to_kif_name
            else
              " " + "・"
            end
          }
          "|" + values.join + "|" + Position::Vpos.parse(y).name
        }
        s = []
        s << "  " + Position::Hpos.zenkaku_units.join(" ")
        s << "+---------------------------+"
        s += rows
        s << "+---------------------------+"
        s.collect{|e|e + "\n"}.join
      end
    end
  end
end
