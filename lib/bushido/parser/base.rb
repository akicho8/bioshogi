# -*- compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

require "time"                  # for Time.parse
require "kconv"                 # for toeuc

require "active_support/core_ext/array/grouping" # for in_groups_of

require_relative "header_info"

module Bushido
  module Parser
    class << self
      # 棋譜ファイルのコンテンツを読み込む
      def parse(str, **options)
        parser = support_parsers.find { |e| e.accept?(str) }
        parser or raise FileFormatError, "棋譜のフォーマットが不明です : #{str}"
        parser.parse(str, options)
      end

      # 棋譜ファイル自体を読み込む
      def parse_file(file, **options)
        parse(Pathname(file).expand_path.read, options)
      end

      # source が Pathname ならそのファイルから読み込み、文字列なら何もしない
      #   こういう設計はいまいちな感もあるけど open-uri で open がURLからも読み込むようになるのに似ているからいいとする
      def source_normalize(source)
        if source.kind_of?(Pathname)
          source = source.expand_path.read
        end
        source.to_s.toutf8.gsub(/\p{blank}*\R/, "\n")
      end

      # 盤面テキストか？
      # private にしていないのは他のクラスでも直接使っているため
      def board_format?(source)
        source_normalize(source).match?(/^\p{blank}*[\+\|]/)
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
      def board_parse(source)
        cell_width = 3

        lines = source_normalize(source).strip.lines.to_a

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

        players = Location.inject({}) do |a, location|
          a.merge(location => [])
        end

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

      private

      def support_parsers
        [KifParser, Ki2Parser]
      end
    end

    # kif/ki2読み込みの共通処理
    class Base
      cattr_accessor(:header_sep) { "：" }

      class << self
        def parse(source, **options)
          new(source, options).tap(&:parse)
        end

        def parse_file(file, **options)
          parse(Pathname(file).expand_path.read, options)
        end

        def accept?(source)
          raise NotImplementedError, "#{__method__} is not implemented"
        end
      end

      attr_reader :header, :move_infos, :first_comments

      def initialize(source, **options)
        @source = source
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

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source)
      end

      private

      def header_read
        normalized_source.scan(/^(\S.*)#{header_sep}(.*)$/o).each do |key, value|
          header[key] = value
        end

        ["開始日時", "終了日時"].each do |e|
          if v = header[e].presence
            header[e] = Time.parse(v).strftime("%Y/%m/%d %H:%M:%S")
          end
        end
      end

      def board_read
        if md = normalized_source.match(/^後手の持駒#{header_sep}.*?\n(?<board>.*)^先手の持駒#{header_sep}/om)
          header[:board_source] = md[:board]
          header[:board] = Parser.board_parse(md[:board])
        end
      end

      def comment_read(line)
        if md = line.match(/^\s*\*\s*(?<comment>.*)/)
          if @move_infos.empty?
            first_comments_add(md[:comment])
          else
            note_add(md[:comment])
          end
        end
      end

      def first_comments_add(comment)
        @first_comments << comment
      end

      # コメントは直前の棋譜の情報と共にする
      def note_add(comment)
        @move_infos.last[:comments] ||= []
        @move_infos.last[:comments] << comment
      end

      concerning :ConverterMethods do
        # CSA標準棋譜ファイル形式
        # http://www.computer-shogi.org/protocol/record_v22.html
        #
        #   V2.2
        #   N+久保利明 王将
        #   N-都成竜馬 四段
        #   $EVENT:王位戦
        #   $SITE:関西将棋会館
        #   $START_TIME:2017/11/16 10:00:00
        #   $END_TIME:2017/11/16 19:04:00
        #   $OPENING:相振飛車
        #   P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
        #   P2 * -HI *  *  *  *  * -KA *
        #   P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
        #   P4 *  *  *  *  *  *  *  *  *
        #   P5 *  *  *  *  *  *  *  *  *
        #   P6 *  *  *  *  *  *  *  *  *
        #   P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
        #   P8 * +KA *  *  *  *  * +HI *
        #   P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
        #   +
        #   +7776FU
        #   -3334FU
        #   %TORYO
        #
        def to_csa(**options)
          options = {
          }.merge(options)

          out = ""
          out << "V2.2\n"

          out << HeaderInfo.collect { |e|
            if v = header[e.kif_key].presence
              e.csa_key + v + "\n"
            end
          }.join

          obj = Mediator.new
          obj.board_reset(header["手合割"])
          out << obj.board.to_csa

          # 手番
          out << Location[:black].csa_sign + "\n"

          out << mediator.hand_logs.collect { |e|
            e.to_s_csa + "\n"
          }.join

          out << "%TORYO" + "\n"

          out
        end

        def to_kif(**options)
          options = {
            length: 12,
            number_width: 4,
          }.merge(options)

          out = ""
          out << header_part_string
          out << "手数----指手---------消費時間--\n"
          out << mediator.hand_logs.collect.with_index(1).collect {|e, i|
            "%*d %s (00:00/00:00:00)\n" % [options[:number_width], i, mb_ljust(e.to_s_kif, options[:length])]
          }.join
          out << "%*d %s\n" % [options[:number_width], mediator.hand_logs.size.next, "投了"]
          out
        end

                                                                                                                                                                                        def to_ki2(**options)
          options = {
            cols: 10,
            # length: 11,
            same_suffix: "　",
          }.merge(options)

          out = ""
          if header.present?
            out << header_part_string
            out << "\n"
          end

          if false
            out << mediator.hand_logs.group_by.with_index{|_, i| i / options[:cols] }.values.collect { |v|
              v.collect { |e|
                s = e.to_s_ki2(with_mark: true, same_suffix: options[:same_suffix])
                mb_ljust(s, options[:length])
              }.join.strip + "\n"
            }.join
          else
            list = mediator.hand_logs.collect do |e|
              e.to_s_ki2(with_mark: true, same_suffix: options[:same_suffix])
            end

            list2 = list.in_groups_of(options[:cols])
            column_widths = list2.transpose.collect do |e|
              e.collect { |e| e.to_s.toeuc.bytesize }.max
            end

            list2 = list2.collect do |a|
              a.collect.with_index do |e, i|
                mb_ljust(e.to_s, column_widths[i])
              end
            end
            out << list2.collect { |e| e.join(" ").strip + "\n" }.join
          end

          out << mediator.judgment_message + "\n"
          out
        end

        def mediator
          @mediator ||= Mediator.new.tap do |mediator|
            mediator.board_reset(header["手合割"]) # FIXME: 盤面が指定されているとき、それを指定する
            move_infos.each do |info|
              mediator.execute(info[:input])
            end
          end
        end

        def header_part_string
          header.collect { |key, value| "#{key}：#{value}\n" }.join
        end

        private

        # mb_ljust("あ", 3)               # => "あ "
        # mb_ljust("1", 3)                # => "1  "
        # mb_ljust("123", 3)              # => "123"
        def mb_ljust(s, w)
          n = w - s.toeuc.bytesize
          if n < 0
            n = 0
          end
          s + " " * n
        end
      end
    end
  end
end
