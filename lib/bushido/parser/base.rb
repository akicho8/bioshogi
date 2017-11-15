# -*- compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-
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
          @header[key] = value
        end
      end

      def board_read
        if md = normalized_source.match(/^後手の持駒#{header_sep}.*?\n(?<board>.*)^先手の持駒#{header_sep}/om)
          @header[:board_source] = md[:board]
          @header[:board] = Parser.board_parse(md[:board])
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
        def to_kif
          out = ""
          header_write(out)
          out << "手数----指手---------消費時間--\n"
          out << mediator.kif_hand_logs.collect.with_index(1).collect {|e, i| "#{i} #{e} (00:00/00:00:00)\n" }.join
          out << "#{mediator.kif_hand_logs.size.next} 投了\n"
          out
        end

        # >> 開始日時：2017/11/11 10:00:00
        # >> 終了日時：2017/11/11 17:22:00
        # >> 棋戦：女流王座戦
        # >> 場所：大阪・芝苑
        # >> 手合割：平手
        # >> 先手：加藤桃子 女王
        # >> 後手：里見香奈 女流王座
        # >> 戦型：ゴキゲン中飛車
        # >>
        # >> ▲2六歩 ▽3四歩 ▲2五歩 ▽3三角 ▲7六歩 ▽4二銀 ▲4八銀 ▽5四歩 ▲6八玉 ▽5五歩
        # >> ▲3六歩 ▽5二飛 ▲3七銀 ▽5三銀 ▲4六銀 ▽4四銀 ▲5八金右 ▽6二玉 ▲7八玉 ▽7二玉
        # >> ▲6六歩 ▽8二玉 ▲6七金 ▽7二銀 ▲7七角 ▽9四歩 ▲8八玉 ▽9五歩 ▲9八香 ▽8四歩
        # >> ▲9九玉 ▽8三銀 ▲8八銀 ▽7二金 ▲6五歩 ▽7四歩 ▲6六金 ▽7三桂 ▲8六角 ▽5一飛
        # >> ▲7八飛 ▽8五歩 ▲5九角 ▽4二角 ▲7九金 ▽3三桂 ▲7五歩 ▽同歩 ▲同金 ▽同角
        # >> ▲同飛 ▽7四歩打 ▲7六飛 ▽7五金打 ▲7八飛 ▽5六歩 ▲同歩 ▽6五金 ▲5五歩 ▽5六歩打
        # >> ▲2六角 ▽1四歩 ▲6二歩打 ▽5二金 ▲6一歩成 ▽同飛 ▲5四歩 ▽6六金 ▲6八飛 ▽7六金
        # >> ▲7七歩打 ▽7五金 ▲5八飛 ▽6六金 ▲6八飛 ▽6五金 ▲3二角打 ▽8六歩 ▲同歩 ▽3五歩
        # >> ▲2三角成 ▽6四歩 ▲3五歩 ▽2一飛 ▲3四馬 ▽9二香 ▲4八角 ▽9一飛 ▲2四歩 ▽7五金
        # >> ▲5六馬 ▽8四歩打 ▲7五角 ▽同歩 ▲6四飛 ▽6三金左 ▲6八飛 ▽6五角打 ▲同飛 ▽同桂
        # >> ▲同馬 ▽5九飛打 ▲6六桂打 ▽7三金直 ▲5二角打 ▽6四金直 ▲同馬 ▽同金 ▲6五歩打 ▽4八角打
        # >> ▲6四歩 ▽6六角成 ▲7三金打
        # >> まで113手で先手の勝ち
        def to_ki2
          out = ""
          if header.present?
            header_write(out)
            out << "\n"
          end
          out << mediator.ki2_hand_logs.group_by.with_index{|_, i|i / 10}.values.collect { |v| v.join(" ") + "\n" }.join
          out << mediator.last_message
          out
        end

        private

        def header_write(io)
          if header.present?
            io << header.collect { |key, value| "#{key}：#{value}\n" }.join
          end
        end

        def mediator
          @mediator ||= Mediator.new.tap do |mediator|
            mediator.board_reset(header["手合割"])
            move_infos.each do |info|
              mediator.execute(info[:input])
            end
          end
        end
      end
    end
  end
end
