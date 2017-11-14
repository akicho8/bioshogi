# -*- compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-
module Bushido
  module Parser
    class << self
      # 棋譜ファイルのコンテンツを読み込む
      def parse(str, **options)
        parser = support_parsers.find { |e| e.resolved?(str) }
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
        source.to_s.toutf8.gsub(/#{WHITE_SPACE}*\R/, "\n")
      end

      # 盤面テキストか？
      # private にしていないのは他のクラスでも直接使っているため
      def board_format?(source)
        source_normalize(source).match?(/^\s*[\+\|]/)
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
          x_units = Position::Hpos.orig_units(zenkaku: true).last(s.gsub("---", "-").count("-"))
        else
          x_units = s.strip.split(/\s+/) # 一行目のX座標の単位取得
        end

        mds = lines.collect { |v| v.match(/\|(?<inline>.*)\|(?<y>.)?/) }.compact
        y_units = mds.collect.with_index { |v, i| v[:y] || Position::Vpos.units(zenkaku: true)[i] }
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
      class << self
        def parse(source, **options)
          new(source, options).tap(&:parse)
        end

        def parse_file(file, **options)
          parse(Pathname(file).expand_path.read, options)
        end

        def resolved?(source)
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
        @_head.scan(/^(\S.*)：(.*)$/).each do |key, value|
          @header[key] = value
        end
      end

      def board_read
        if md = @_head.match(/^後手の持駒：.*?\n(?<board>.*)^先手の持駒：/m)
          @header[:board_source] = md[:board]
          @header[:board] = Parser.board_parse(md[:board])
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
  end
end
