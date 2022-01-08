module Bioshogi
  module Parser
    concern :KakinokiMethods do
      included do
        cattr_accessor(:kknk_system_comment_char) { "#" }
        cattr_accessor(:kknk_key_value_sep) { "：" }
      end

      def kknk_header_read
        @kif_head_str = normalized_source

        # 厳密ではないけど上部に絞る
        if md = @kif_head_str.match(/(?<header_dirty_part>.*?)^(#{KifParser.kif_separator}|[▲△]|まで)/mo)
          @kif_head_str = md[:header_dirty_part]
        end

        # 扱いやすいように全角スペースを半角化
        @kif_head_str = @kif_head_str.gsub(/\p{blank}/, " ")

        # システムコメント行を削除
        @kif_head_str = @kif_head_str.remove(/^\s*#{kknk_system_comment_char}.*(\R|$)/o)

        key_value_split_and_store

        # 持駒の読み取り
        Location.each do |e|
          if v = e.call_names.collect { |e| header["#{e}の持駒"] }.join.presence
            @player_piece_boxes[e.key].set(Piece.s_to_h(v))
          end
        end

        # 「上手番」「後手番」の指定があれば
        Location.each do |location|
          if location.call_names.any? { |name| normalized_source.match?(/^#{name}番/) }
            @force_location = location
            break
          end
        end

        if v = header["手合割"]
          if e = PresetInfo[v]
            @force_preset_info = e
            if e.handicap
              @force_handicap = e.handicap
            end
          end
        end

        # if v = handicap_validity2
        #   if !v.nil?
        #     @force_handicap = true
        #   end
        # end
      end

      def key_value_split_and_store
        # 一行になっている「*解説：佐藤康光名人　聞き手：矢内理絵子女流三段」を整形する
        # @kif_head_str = @kif_head_str.gsub(/[\*\s]+(解説|聞き手)：\S+/) { |s| "\n#{s.strip}\n" }

        # ぴよ将棋の「手合割：その他」があると手合割にその他は存在しないため削除する
        # @kif_head_str = @kif_head_str.sub(/^\s*手合割：その他.*(\R|$)/, "")

        # ヘッダーは自由にカスタマイズできるのに何かのソフトの都合で受け入れられないキーワードがあるらしく、
        # "*キー：値" のように * でコメントアウトしてヘッダーを入れている場合がある
        # そのため * を外して取り込んでいる → そのまま取り込むことにする(2020-11-16)
        #
        # "foo\nbar:1".scan(/^([^:\n]+):(.*)/).to_a # => [["bar", "1"]]
        #
        @kif_head_str.scan(/^\s*([^#{kknk_key_value_sep}\n]+)#{kknk_key_value_sep}(.*)$/o).each do |key, value|
          # key = key.remove(/^\*+/)
          header[key.strip] = value.strip
        end

        # @raw_header = header.dup

        # # 「a」vs「b」を取り込む
        # if md = @kif_head_str.match(/\*「(.*?)」?vs「(.*?)」?$/)
        #   call_names.each.with_index do |e, i|
        #     key = "#{e}詳細"
        #     v = normalize_value(md.captures[i])
        #     header[key] = v
        #     # meta_info[key] = v
        #   end
        # end
      end

      def kknk_board_read
        if md = normalized_source.match(/(?<board>^\+\-.*\-\+$)/m)
          @board_source = md[:board]
          @force_preset_info ||= Board.guess_preset_info(@board_source)
        end
      end

      def kknk_comment_read(line)
        if md = line.match(/^\p{blank}*\*\p{blank}*(?<comment>.*)/)
          if @move_infos.empty?
            first_comments_add(md[:comment])
          else
            note_add(md[:comment])
          end
        end
      end

      private

      def first_comments_add(comment)
        @first_comments << comment
      end

      # コメントは直前の棋譜の情報と共にする
      def note_add(comment)
        @move_infos.last[:comments] ||= []
        @move_infos.last[:comments] << comment
      end

      def handicap_validity2
        raise "使用禁止。上手・下手の名前があるからといって先後を判定してはいけない。柿木将棋の変則的なKIFは詰将棋に上手・下手を用いるためこれで判定すると整合性が取れなくなる"

        if Location.any? {|e| header.has_key?(e.handicap_name) || header.has_key?("#{e.handicap_name}の持駒") }
          return true
        end

        if Location.any? {|e| header.has_key?(e.equality_name) || header.has_key?("#{e.equality_name}の持駒") }
          return false
        end

        nil
      end
    end
  end
end
