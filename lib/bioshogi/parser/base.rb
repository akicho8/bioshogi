# -*- compile-command: "bundle execute rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

require_relative "header"
require_relative "csa_header_info"
require_relative "last_action_info"

require_relative "kif_formatter"
require_relative "ki2_formatter"
require_relative "csa_formatter"
require_relative "usi_formatter"
require_relative "bod_formatter"
require_relative "png_formatter"

module Bioshogi
  module Parser
    class Base
      cattr_accessor(:header_sep) { "：" }

      class << self
        def parse(source, **options)
          new(source, options).tap(&:parse)
        end

        def file_parse(file, **options)
          parse(Pathname(file).expand_path.read, options)
        end

        def accept?(source)
          raise NotImplementedError, "#{__method__} is not implemented"
        end
      end

      attr_reader :move_infos, :first_comments, :last_status_params, :board_source, :error_message

      def initialize(source, **parser_options)
        @source = source
        @parser_options = default_parser_options.merge(parser_options)

        @move_infos = []
        @first_comments = []
        @board_source = nil
        @last_status_params = nil
        @error_message = nil
      end

      def default_parser_options
        {
          # embed: 二歩の棋譜なら例外を出さずに直前で止めて反則であることを棋譜に記す
          #  skip: 棋譜には記さない
          # false: 例外を出す(デフォルト)
          typical_error_case: false,
          # run_and_build_skip: false,
          skill_monitor_enable: true,
          skill_monitor_technique_enable: true,

          validate_skip: false,           # 将棋ウォーズの棋譜なら指定すると少し速くなる
          candidate_skip: false, # ki2にしないのであれば指定するとかなり速くなる

          support_for_piyo_shogi_v4_1_5: false, # ぴよ将棋でKIFが読めるようにする
        }
      end

      # def parse
      #   unless @parser_options[:run_and_build_skip]
      #     mediator_run
      #   end
      # end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source)
      end

      def header
        @header ||= Header.new
      end

      private

      def header_read
        header.parse_from_kif_format_header(normalized_source)
      end

      def header_normalize
        header.normalize_all
      end

      def board_read
        if md = normalized_source.match(/(?<board>^\+\-.*\-\+$)/m)
          @board_source = md[:board]
        end
      end

      def comment_read(line)
        if md = line.match(/^\p{blank}*\*\p{blank}*(?<comment>.*)/)
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
        include KifFormatter
        include Ki2Formatter
        include CsaFormatter
        include UsiFormatter
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
          if header.turn_counter
            mediator.turn_info.counter = header.turn_counter
          end

          # KIFに手数の表記があって2手目から始まっているなら2手目までカウンタを進める
          if e = move_infos.first
            if v = e[:turn_number]
              mediator.turn_info.counter += v.to_i.pred
            end
          end

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
            move_infos.each do |info|
              if @parser_options[:debug]
                p mediator
              end
              if @parser_options[:callback]
                @parser_options[:callback].call(mediator)
              end
              if @parser_options[:turn_limit] && mediator.turn_info.turn_max >= @parser_options[:turn_limit]
                break
              end
              mediator.execute(info[:input])
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
          # 棋譜の実行結果から見た判断を初期値として
          key = :TORYO
          if @error_message
            key = :ILLEGAL_MOVE
          end
          last_action_info = LastActionInfo[key]

          # 元の棋譜の記載を優先
          if @last_status_params
            if v = LastActionInfo[@last_status_params[:last_action_key]]
              last_action_info = v
            end
          end

          last_action_info
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
end
