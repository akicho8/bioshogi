# frozen-string-literal: true

require_relative "kif_formatter"
require_relative "ki2_formatter"
require_relative "csa_formatter"
require_relative "sfen_formatter"
require_relative "bod_formatter"
require_relative "png_formatter"

module Bioshogi
  module Formatter
    concern :Anything do
      include KifFormatter
      include Ki2Formatter
      include CsaFormatter
      include SafenFormatter
      include BodFormatter
      include PngFormatter

      def mediator_run
        mediator
      end

      def mediator_new
        Mediator.new.tap do |e|
          e.params.update(@parser_options.slice(*[
                :skill_monitor_enable,
                :skill_monitor_technique_enable,
                :candidate_skip,
                :validate_skip,
              ]))
        end
      end

      def mediator
        @mediator ||= mediator_new.tap do |e|
          board_setup(e)
          mediator_run_all(e)
        end
      end

      def board_setup(mediator)
        Location.each do |e|
          e.call_names.each do |e|
            if v = header["#{e}の持駒"]
              mediator.player_at(e).piece_box.set(Piece.s_to_h(v))
            end
          end
        end

        if @board_source
          mediator.board.placement_from_shape(@board_source)
        else
          mediator.placement_from_preset(header["手合割"] || "平手")
        end

        mediator.turn_info.handicap = handicap?

        # 手数＝xxx の読み取り
        if header.turn_counter
          mediator.turn_info.counter = header.turn_counter
        end

        # KIFに手数の表記があって2手目から始まっているなら2手目までカウンタを進める
        if e = move_infos.first
          if v = e[:turn_number]
            mediator.turn_info.counter += v.to_i.pred
          end
        end

        # これに対応
        #
        # 先手の備考：居飛車, 相居飛車, 居玉, 相居玉
        # 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
        # 後手の持駒：銀 歩三
        #   ９ ８ ７ ６ ５ ４ ３ ２ １
        # +---------------------------+
        # |v香v飛 ・ ・ ・ ・v玉v桂v香|一
        # | ・ ・ ・v金 ・ ・v金v銀 ・|二
        # | ・ ・ ・ ・v歩v歩 歩 ・ ・|三
        # |v歩 ・ ・ ・ ・v角 桂v歩v歩|四
        # | ・ ・v歩 銀v銀 桂 ・ ・ ・|五
        # | 歩 歩 歩 歩 ・ 歩 ・ ・ 歩|六
        # | ・ ・ 桂 ・ 歩 ・ 金 ・ ・|七
        # | ・ ・ 金 ・ ・ ・ ・ ・ ・|八
        # | 香 ・ 玉 ・ ・ ・ ・ 飛 香|九
        # +---------------------------+
        # 先手の持駒：角 歩
        # 手数----指手---------消費時間--
        #   72 投了
        # まで71手で先手の勝ち
        #
        # 72 で投了ということは 71 まで進める
        #
        if move_infos.empty?
          if @last_status_params
            if v = @last_status_params[:turn_number]
              mediator.turn_info.counter = v.to_i.pred
            end
          end
        end

        # さらに
        # "まで71手で先手の勝ち"
        # の部分を見てカウンタをセットすることもできるけど
        # まだ必要になってないのでやらない

        mediator.before_run_process # 最初の状態を記録
      end

      def handicap?
        v = header.handicap_validity
        if !v.nil?
          return v
        end

        if e = board_preset_info
          if e.key != :"平手"
            return true
          end
        end

        false
      end

      # 盤面の指定があるとき、盤面だけを見て、手合割を得る
      def board_preset_info
        @board_preset_info ||= -> {
          if @board_source
            # mediator = Mediator.new
            # mediator.board.placement_from_shape(@board_source)
            # mediator.board.preset_info

            board = Board.new
            board.placement_from_shape(@board_source)
            board.preset_info

          end
        }.call
      end

      # 手合割
      def preset_info
        @preset_info ||= board_preset_info || PresetInfo.fetch(header["手合割"] || "平手")
      end

      # names_set(black: "alice", white: "bob")
      def names_set(params)
        locations = Location.send(handicap? ? :reverse_each : :itself)
        locations.each do |e|
          header[e.call_name(handicap?)] = params[e.key] || "？"
        end
      end

      def mediator_run_all(mediator)
        # FIXME: ここらへんは mediator のなかで実行する
        begin
          move_infos.each.with_index do |info, i|
            if @parser_options[:debug]
              p mediator
            end
            if @parser_options[:callback]
              @parser_options[:callback].call(mediator)
            end
            if @parser_options[:turn_limit] && mediator.turn_info.turn_max >= @parser_options[:turn_limit]
              break
            end

            mediator.execute(info[:input], used_seconds: used_seconds_at(i))
          end
        rescue CommonError => error
          if v = @parser_options[:typical_error_case]
            case v
            when :embed
              @error_message = error.message
            when :skip
            else
              raise MustNotHappen
            end
          else
            raise error
          end
        end

        if @parser_options[:skill_monitor_enable]
          # 両方が入玉していれば「相入玉」タグを追加する
          # この場合、両方同時に入玉しているかどうかは判定できない
          if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["入玉"]) }
            mediator.players.each do |player|
              player.skill_set.list_push(NoteInfo["相入玉"])
            end
          end

          if ENV["BIOSHOGI_ENV"] != "test"
            # 1. 最初に設定
            # とりあえず2つに分けたいので「振り飛車」でなければ「居飛車」としておく
            if preset_info
              if preset_info.special_piece
                mediator.players.each do |player|
                  if !player.skill_set.has_skill?(NoteInfo["振り飛車"]) && !player.skill_set.has_skill?(NoteInfo["居飛車"])
                    !player.skill_set.list_push(NoteInfo["居飛車"])
                  end
                end

                if true
                  # 両方居飛車なら相居飛車
                  if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["居飛車"]) }
                    mediator.players.each do |player|
                      player.skill_set.list_push(NoteInfo["相居飛車"])
                    end
                  end

                  # 両方振り飛車なら相振り
                  if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                    mediator.players.each do |player|
                      player.skill_set.list_push(NoteInfo["相振り"])
                    end
                  end

                  # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
                  if player = mediator.players.find { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                    others = mediator.players - [player]
                    if others.none? { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                      others.each { |e| e.skill_set.list_push(NoteInfo["対振り"]) }
                      mediator.players.each { |e| e.skill_set.list_push(NoteInfo["対抗型"]) }
                    end
                  end
                end
              end

              # if mediator.players.any? { |e| e.skill_set.note_infos.include?(NoteInfo["振り飛車"]) }
              #   mediator.players.each do |player|
              #     player.skill_set.list_push(NoteInfo["相振り飛車"])
              #   end
              # end

              if true
                # どれかの手合割に該当すれば玉は定位置から始まっていることがかある
                # 居玉チェック
                mediator.players.each do |e|
                  if e.king_moved_counter.zero?
                    e.skill_set.list_push(NoteInfo["居玉"])
                  end
                end

                if mediator.players.all? { |e| e.king_moved_counter.zero? }
                  mediator.players.each do |e|
                    e.skill_set.list_push(NoteInfo["相居玉"])
                  end
                end
              end
            end
          end

          # ヘッダーに埋める
          TacticInfo.each do |e|
            mediator.players.each do |player|
              if v = player.skill_set.public_send(e.list_key).normalize.uniq.collect(&:name).presence # 手筋の場合、複数になる場合があるので uniq している
                skill_set_hash["#{player.call_name}の#{e.name}"] = v
              end
            end
          end
          header.object.update(skill_set_hash.transform_values { |e| e.join(", ") })
        end
      end

      def skill_set_hash
        @skill_set_hash ||= {}
      end

      def header_part_string
        @header_part_string ||= __header_part_string
      end

      def judgment_message
        mediator_run

        # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
        if true
          if @last_status_params
            v = @last_status_params[:last_action_key]
            unless LastActionInfo[v]
              if v == "反則勝ち"
                v = "#{mediator.current_player.call_name}の手番なのに#{mediator.opponent_player.call_name}が投了 (将棋倶楽部24だけに存在する「反則勝ち」)"
              end
              # "*" のあとにスペースを入れると、激指でコメントの先頭にスペースが入ってしまうため、仕方なくくっつけている
              return "*#{v}"
            end
          end
        end

        last_action_info.judgment_message(mediator)
      end

      def raw_header_part_hash
        header.object.collect { |key, value|
          if value
            if e = CsaHeaderInfo[key]
              if e.as_kif
                value = e.instance_exec(value, &e.as_kif)
              end
            end
            [key, value]
          end
        }.compact.to_h
      end

      def last_action_info
        key = nil

        # エラーなら最優先
        unless key
          if @error_message
            key = :ILLEGAL_MOVE
          end
        end

        # 元の棋譜の記載を優先
        unless key
          if @last_status_params
            v = @last_status_params[:last_action_key]
            if LastActionInfo[v]
              key = v
            end
          end
        end

        LastActionInfo.fetch(key || :TORYO)
      end

      private

      def __header_part_string
        mediator_run

        obj = Mediator.new
        board_setup(obj)

        if e = obj.board.preset_info
          header["手合割"] = e.name

          # 手合割がわかるとき持駒が空なら消す
          Location.each do |e|
            e.call_names.each do |e|
              key = "#{e}の持駒"
              if v = header[key]
                if v.blank?
                  header.delete(key)
                end
              end
            end
          end

          raw_header_part_string
        else
          # 手合がわからないので図を出す場合
          # 2つヘッダー行に挟む形になっている仕様が特殊でデータの扱いが難しい

          # header["手合割"] ||= "その他"

          # 「なし」を埋める
          Location.each do |location|
            key = "#{location.call_name(obj.turn_info.handicap?)}の持駒"
            v = header[key]
            if v.blank?
              header[key] = "なし"
            end
          end

          # 駒落ちの場合は「上手」「下手」の順に並べる (盤面をその間に入れるため)
          Location.reverse_each do |e|
            key = "#{e.call_name(obj.turn_info.handicap?)}の持駒"
            if v = header.delete(key)
              header[key] = v
            end
          end

          s = raw_header_part_string
          key = "#{Location[:white].call_name(obj.turn_info.handicap?)}の持駒"
          s.gsub(/(#{key}：.*\n)/, '\1' + obj.board.to_s)
        end
      end

      def raw_header_part_string
        s = raw_header_part_hash.collect { |key, value| "#{key}：#{value}\n" }.join

        if @parser_options[:support_for_piyo_shogi_v4_1_5]
          s = s.gsub(/(の持駒：.*)$/, '\1 ')
        end

        s

      end

      # mb_ljust("あ", 3)               # => "あ "
      # mb_ljust("1", 3)                # => "1  "
      # mb_ljust("123", 3)              # => "123"
      def mb_ljust(s, w)
        n = w - s.encode("EUC-JP").bytesize
        if n < 0
          n = 0
        end
        s + " " * n
      end

      def clock_exist?
        if e = @move_infos.last
          e[:used_seconds].to_i >= 1
        end
      end

      def used_seconds_at(index)
        @move_infos.dig(index, :used_seconds).to_i
      end

      def error_message_part(comment_mark = "*")
        if @error_message
          v = @error_message.strip + "\n"
          s = "-" * 76 + "\n"
          [s, *v.lines, s].collect {|e| "#{comment_mark} #{e}" }.join
        end
      end
    end
  end
end
