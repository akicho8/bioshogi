# -*- compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-
# frozen-string-literal: true

require "time"                  # for Time.parse
require "kconv"                 # for toeuc

require "active_support/core_ext/array/grouping" # for in_groups_of
require "active_support/core_ext/numeric"        # for 1.minute

require_relative "csa_header_info"
require_relative "last_action_info"

module Bushido
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

      attr_reader :header, :move_infos, :first_comments, :last_status_params, :board_source, :error_message

      def initialize(source, **config)
        @source = source
        @config = default_config.merge(config)

        @header = {}
        @move_infos = []
        @first_comments = []
        @board_source = nil
        @last_status_params = nil
        @error_message = nil
      end

      def default_config
        {
          # embed: 二歩の棋譜なら例外を出さずに直前で止めて反則であることを棋譜に記す
          #  skip: 棋譜には記さない
          # false: 例外を出す(デフォルト)
          typical_error_case: false,
          # run_and_build_skip: false,
          skill_set_flag: true,
        }
      end

      # def parse
      #   unless @config[:run_and_build_skip]
      #     mediator_run
      #   end
      # end

      def parse
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source)
      end

      private

      def header_read
        s = normalized_source
        s = s.gsub(/^[#*].*/, "") # "*" 以降を外さないと二歩のときに埋め込んだ盤面の下にある持駒情報を取り込んでしまう
        s.scan(/^(\S.*)#{header_sep}(.*)$/o).each do |key, value|
          header[key] = value
        end
      end

      def header_normalize
        # 正規化。別にしなくてもいい
        if true
          # 日時を整える
          ["開始日時", "終了日時"].each do |e|
            if v = header[e].presence
              if v = (Time.parse(v) rescue nil)
                if [v.hour, v.min, v.sec].all?(&:zero?)
                  format = "%Y/%m/%d"
                else
                  format = "%Y/%m/%d %H:%M:%S"
                end
                header[e] = v.strftime(format)
              end
            end
          end

          # 並びを綺麗にする
          Location.each do |e|
            e.call_names.each do |e|
              key = "#{e}の持駒"
              if v = header[key].presence
                v = Utils.hold_pieces_s_to_a(v)
                v = Utils.hold_pieces_a_to_s(v, ordered: true, separator: " ")
                if v
                  header[key] = v
                else
                  header.delete(key)
                end
              end
            end
          end
        end
      end

      def board_read
        # FIXME: 間にある前提ではなく、どこに書いていても拾えるようにしたい
        if md = normalized_source.match(/^(?:後手|上手)の持駒#{header_sep}.*?\n(?<board>.*)^(?:先手|下手)の持駒#{header_sep}/om)
          @board_source = md[:board].presence
          # header[:board] = BoardParser.parse(md[:board]) # TODO: 使ってない
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
            board_expansion: false,
            strip: false, # テストですぐに差分が出てしまって転けるので右側のスペースを取る
          }.merge(options)

          mediator_run

          out = []
          out << "V2.2\n"

          out << CsaHeaderInfo.collect { |e|
            if v = header[e.kif_side_key].presence
              if e.as_csa
                v = e.instance_exec(v, &e.as_csa)
              end
              "#{e.csa_key}#{v}\n"
            end
          }.join

          teaiwari_name = nil
          if true
            obj = Mediator.new
            obj.board_reset_old(@board_source || header["手合割"])
            teaiwari_name = obj.board.teaiwari_name
            if teaiwari_name
              out << "#{Parser::CsaParser.comment_char} 手合割:#{teaiwari_name}\n"
            end
            if options[:board_expansion]
              out << obj.board.to_csa
            else
              if teaiwari_name == "平手"
                out << "PI\n"
              else
                out << obj.board.to_csa
              end
            end
          end

          # 2通りある
          # 1. 初期盤面の状態から調べた手合割を利用して最初の手番を得る  (turn_info = TurnInfo.new(teaiwari_name))
          # 2. mediator.turn_info を利用する
          out << mediator.turn_info.base_location.csa_sign + "\n"

          out << mediator.hand_logs.collect.with_index { |e, i|
            if clock_exist?
              "#{e.to_s_csa},T#{used_seconds_at(i)}\n"
            else
              e.to_s_csa + "\n"
            end
          }.join

          if e = @last_status_params
            last_action_info = LastActionInfo.fetch(e[:last_action_key])
            s = "%#{last_action_info.csa_key}"
            if v = e[:used_seconds]
              s += ",T#{v}"
            end
            out << "#{s}\n"
          else
            out << "%TORYO" + "\n"
          end

          if @error_message
            out << error_message_part(Parser::CsaParser.comment_char)
          end

          out = out.join

          # テスト用
          if options[:strip]
            out = out.gsub(/\s+\n/, "\n")
          end

          out
        end

        concerning :ToKifMethods do
          def to_kif(**options)
            options = {
              length: 12,
              number_width: 4,
              header_skip: false,
            }.merge(options)

            mediator_run

            out = []
            unless options[:header_skip]
              out << header_part_string
            end
            out << "手数----指手---------消費時間--\n"

            chess_clock = ChessClock.new
            out << mediator.hand_logs.collect.with_index.collect { |e, i|
              chess_clock.add(used_seconds_at(i))
              s = "%*d %s %s\n" % [options[:number_width], i.next, mb_ljust(e.to_s_kif, options[:length]), chess_clock]
              if v = e.to_skill_set_kif_comment
                s += v
              end
              s
            }.join

            ################################################################################

            left_part = "%*d %s" % [options[:number_width], mediator.hand_logs.size.next, mb_ljust(last_action_info.kif_word, options[:length])]
            right_part = nil

            if true
              if @last_status_params
                if used_seconds = @last_status_params[:used_seconds]
                  chess_clock.add(used_seconds)
                  right_part = chess_clock.to_s
                end
              end
            end

            out << "#{left_part} #{right_part}".rstrip + "\n"
            out << judgment_message + "\n"
            out << error_message_part

            out.join
          end
        end

        def to_ki2(**options)
          options = {
            cols: 10,
            # length: 11,
            same_suffix: "　",
            header_skip: false,
          }.merge(options)

          mediator_run

          out = []
          if header.present? && !options[:header_skip]
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

          out << judgment_message + "\n"
          out << error_message_part

          out.join
        end

        concerning :ToSfenMethods do
          def to_sfen(**options)
            options = {
            }.merge(options)

            mediator.to_sfen(options)
          end
        end

        def mediator_run
          mediator
        end

        def mediator_new
          Mediator.new.tap do |mediator|
            mediator.config[:skill_set_flag] = @config[:skill_set_flag]
          end
        end

        def mediator
          @mediator ||= mediator_new.tap do |mediator|
            mediator_board_setup(mediator)
            mediator_run_all(mediator)
          end
        end

        def mediator_board_setup(mediator)
          Location.each do |e|
            e.call_names.each do |e|
              if v = header["#{e}の持駒"]
                mediator.player_at(e).pieces_set(v)
              end
            end
          end

          if @board_source
            mediator.board_reset_by_shape(@board_source)
            mediator.turn_info_auto_set

            if mediator.board.teaiwari_name != "平手"
              if header["手合割"].blank? || header["手合割"] == "その他"
                mediator.turn_info.komaochi = true
              end
            end
          else
            mediator.board_reset(header["手合割"] || "平手")
          end
        end

        def mediator_run_all(mediator)
          begin
            move_infos.each do |info|
              mediator.execute(info[:input])
            end
          rescue TypicalError => error
            if v = @config[:typical_error_case]
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

          if @config[:skill_set_flag]
            TacticInfo.each do |e|
              mediator.players.each do |player|
                header["#{player.call_name}の#{e.name}"] = player.skill_set.public_send("normalized_#{e.var_key}").collect(&:name).join(", ")
              end
            end
          end
        end

        def header_part_string
          @header_part_string ||= __header_part_string
        end

        def judgment_message
          mediator_run
          last_action_info.judgment_message(mediator)
        end

        def raw_header_part_hash
          header.collect { |key, value|
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

        private

        def __header_part_string
          out = []

          mediator_run

          obj = Mediator.new
          if @board_source
            obj.board_reset_by_shape(@board_source)
            if header["手合割"].blank? || header["手合割"] == "その他"
              obj.turn_info.komaochi = true
            else
              obj.turn_info_auto_set
            end
          else
            obj.board_reset(header["手合割"] || "平手")
          end

          if v = obj.board.teaiwari_name
            header["手合割"] = v

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

            out << raw_header_part_string
          else
            # 手合がわからないので図を出す場合
            # 2つヘッダー行に挟む形になっている仕様が特殊でデータの扱いが難しい

            header["手合割"] ||= "その他"

            Location.each do |location|
              key = "#{location.call_name(obj.turn_info.komaochi?)}の持駒"
              v = header[key]
              if v.blank?
                header[key] = "なし"
              end
            end
            s = raw_header_part_string
            out << s.gsub(/(#{Location[:white].call_name(obj.turn_info.komaochi?)}の持駒：.*\n)/, '\1' + obj.board.to_s)
          end

          out.join
        end

        def raw_header_part_string
          raw_header_part_hash.collect { |key, value| "#{key}：#{value}\n" }.join
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
          @clock_exist ||= @move_infos.any? {|e| e[:used_seconds] && e[:used_seconds].to_i >= 1 }
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

        class ChessClock
          def initialize
            @single_clocks = Location.inject({}) {|a, e| a.merge(e => SingleClock.new) }
            @counter = 0
          end

          def add(v)
            @single_clocks[Location[@counter]].add(v)
            @counter += 1
          end

          def latest_clock_format
            @single_clocks[Location[@counter.pred]].to_s
          end

          def to_s
            latest_clock_format
          end

          class SingleClock
            def initialize
              @total = 0
              @used = 0
            end

            def add(v)
              v = v.to_i
              @total += v
              @used = v
            end

            def to_s
              h, r = @total.divmod(1.hour)
              m, s = r.divmod(1.minute)
              "(%02d:%02d/%02d:%02d:%02d)" % [*@used.divmod(1.minute), h, m, s]
            end
          end
        end
      end
    end
  end
end
