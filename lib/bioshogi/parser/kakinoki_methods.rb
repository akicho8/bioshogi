module Bioshogi
  module Parser
    # kif, ki2, bod に関係する処理だけ書くこと(重要)
    # 間違って mi.header.rb に書いてしまってるのはどんどんこっちに移動させること
    # mi.header.rb は CSA から見て不要なものが入っていてはいけない
    concern :KakinokiMethods do
      SYSTEM_COMMENT_CHAR        = "#"
      KEY_VALUE_SEPARATOR        = "："

      BOARD_REGEXP               = /(?<board>^\+\-.*\-\+$)/m
      COMMENT_REGEXP             = /^\p{blank}*\*\p{blank}*(?<comment>.*)/
      KEY_VALUE_REGEXP           = /^\s*([^#{KEY_VALUE_SEPARATOR}\n]+)#{KEY_VALUE_SEPARATOR}(.*)$/o
      SYSTEM_COMMENT_LINE_REGEXP = /^\s*#{SYSTEM_COMMENT_CHAR}.*(\R|$)/o
      HEADER_BODY_SEP_REGEXP     = /手数-+指手-+消費時間/
      HEADER_PART_REGEXP         = /(?<header_dirty_part>.*?)^(#{HEADER_BODY_SEP_REGEXP}|[▲△☗☖▼▽]|まで)/mo

      def parse
        header_extract          # ヘッダー部分だけを抽出して扱いやすいテキストにする
        key_value_store         # ヘッダーのキーと値のペアをとりあえず取り込む
        unnecessary_keys_remove # 不要なキーの削除
        player_piece_read       # そこから持駒の読み取る
        force_preset_read       # 明示的な手合割の指定があれば読み取る (駒落ちモードに移行するのはここからだけ)
        force_location_read     # 明示的な手番の指定があれば読み取る (あとでベースを切り替える)
        kknk_board_read         # 盤面の読み取り
        body_parse              # 指し手の読み取り
        mi.header.normalize        # ヘッダーの書き換え
      end

      def kknk_board_read
        if md = normalized_source.match(BOARD_REGEXP)
          @mi.board_source = md[:board]
          @force_preset_info ||= Board.guess_preset_info(@mi.board_source)
        end
      end

      def kknk_comment_read(line)
        if md = line.match(COMMENT_REGEXP)
          if @mi.move_infos.empty?
            first_comments_add(md[:comment])
          else
            command_add(md[:comment])
          end
        end
      end

      private

      def body_part
        @body_part ||= yield_self do
          # 激指で作った分岐対応KIFを読んだ場合「変化：8手」のような文字列が来た時点で打ち切る
          normalized_source.remove(/^\p{blank}*変化：.*/m)
        end
      end

      def header_extract
        @kknk_head = normalized_source

        # 厳密ではないけど上部に絞る
        if md = @kknk_head.match(HEADER_PART_REGEXP)
          @kknk_head = md[:header_dirty_part]
        end

        # 扱いやすいように全角スペースを半角化
        @kknk_head = @kknk_head.gsub(/\p{blank}+/, " ")

        # システムコメント行を削除
        @kknk_head = @kknk_head.remove(SYSTEM_COMMENT_LINE_REGEXP)
      end

      # 2020-11-16
      # ヘッダーは自由にカスタマイズできるのに何かのソフトの都合で受け入れられないキーワードがある
      # そのため "*キー：値" のように * でコメントアウトしてヘッダーを入れている場合がある
      # なので * を外して取り込むようにした
      # しかし、受け入れないソフトがいるためアスタリスク込みで取り込むことにする
      def key_value_store
        # "foo\nbar:1".scan(/^([^:\n]+):(.*)/).to_a # => [["bar", "1"]]
        @kknk_head.scan(KEY_VALUE_REGEXP).each do |key, value|
          mi.header[key.strip] = value.strip
        end
      end

      def unnecessary_keys_remove
        mi.header.object.delete("変化")
      end

      def player_piece_read
        Location.each do |e|
          if v = e.call_names.collect { |e| mi.header["#{e}の持駒"] }.join.presence
            @player_piece_boxes[e.key].set(Piece.s_to_h(v))
          end
        end
      end

      def force_location_read
        Location.each do |location|
          if location.call_names.any? { |name| normalized_source.match?(/^#{name}番/) }
            @force_location = location
            break
          end
        end
      end

      def force_preset_read
        if v = mi.header["手合割"]
          if e = PresetInfo[v]
            @force_preset_info = e
            if e.handicap
              @force_handicap = e.handicap
            end
          end
        end
      end

      def first_comments_add(comment)
        @mi.first_comments << comment
      end

      # コメントは直前の棋譜の情報と共にする
      def command_add(comment)
        @mi.move_infos.last[:comments] ||= []
        @mi.move_infos.last[:comments] << comment
      end
    end
  end
end
