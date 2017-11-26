# -*- compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

require "time"                  # for Time.parse
require "kconv"                 # for toeuc

require "active_support/core_ext/array/grouping" # for in_groups_of
require "active_support/core_ext/numeric"        # for 1.minute

require_relative "header_info"
require_relative "toryo_info"

module Bushido
  module Parser
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
        @board_source = nil
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
        s = normalized_source
        s = s.gsub(/^#.*/, "")
        s.scan(/^(\S.*)#{header_sep}(.*)$/o).each do |key, value|
          header[key] = value
        end
      end

      def header_normalize
        # 正規化。別にしなくてもいい
        if true
          ["開始日時", "終了日時"].each do |e|
            if v = header[e].presence
              header[e] = Time.parse(v).strftime("%Y/%m/%d %H:%M:%S") rescue nil
            end
          end

          Location.each do |e|
            key = "#{e.name}の持駒"
            if v = header[key]
              v = Utils.hold_pieces_s_to_a(v)
              v = Utils.hold_pieces_a_to_s(v, ordered: true, separator: " ")
              header[key] = v
            end
          end
        end
      end

      def board_read
        # FIXME: 間にある前提ではなく、どこに書いていても拾えるようにしたい
        if md = normalized_source.match(/^後手の持駒#{header_sep}.*?\n(?<board>.*)^先手の持駒#{header_sep}/om)
          @board_source = md[:board]
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
          }.merge(options)

          out = ""
          out << "V2.2\n"

          out << HeaderInfo.collect { |e|
            if v = header[e.replace_key].presence
              "#{e.csa_key}#{v}\n"
            end
          }.join

          if true
            obj = Mediator.new
            obj.board_reset(@board_source || header["手合割"])
            if options[:board_expansion]
              out << obj.board.to_csa
            else
              if obj.board.teai_name == "平手"
                out << "PI\n"
              else
                out << obj.board.to_csa
              end
            end
          end

          # 手番
          out << Location[:black].csa_sign + "\n"

          out << mediator.hand_logs.collect.with_index { |e, i|
            if clock_exist?
              "#{e.to_s_csa},T#{used_seconds_at(i)}\n"
            else
              e.to_s_csa + "\n"
            end
          }.join

          if e = @csa_last_status_info
            s = "%#{e[:last_behaviour]}"
            if v = e[:used_seconds].presence
              s += ",T#{v}"
            end
            out << "#{s}\n"
          else
            out << "%TORYO" + "\n"
          end

          out
        end

        def to_kif(**options)
          options = {
            length: 12,
            number_width: 4,
            header_skip: false,
          }.merge(options)

          out = ""
          out << header_as_string unless options[:header_skip]
          out << "手数----指手---------消費時間--\n"

          chess_clock = ChessClock.new
          out << mediator.hand_logs.collect.with_index.collect {|e, i|
            chess_clock.add(used_seconds_at(i))
            "%*d %s %s\n" % [options[:number_width], i.next, mb_ljust(e.to_s_kif, options[:length]), chess_clock]
          }.join

          toryo_info = ToryoInfo[:TORYO]
          if @csa_last_status_info
            if v = ToryoInfo[@csa_last_status_info[:last_behaviour]]
              toryo_info = v
            end
          end

          left_part = "%*d %s" % [options[:number_width], mediator.hand_logs.size.next, mb_ljust(toryo_info.kif_diarect, options[:length])]
          right_part = ""

          if @csa_last_status_info
            if used_seconds = @csa_last_status_info[:used_seconds].presence
              chess_clock.add(used_seconds)
              right_part << " #{chess_clock}"
            end
          end

          out << "#{left_part}#{right_part}".rstrip + "\n"
          out
        end

        def to_ki2(**options)
          options = {
            cols: 10,
            # length: 11,
            same_suffix: "　",
            header_skip: false,
          }.merge(options)

          out = ""
          if header.present? && !options[:header_skip]
            out << header_as_string
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

            # 手合割：平手　　
            # 後手の持駒：飛二　角　銀二　桂四　香四　歩九　
            #   ９ ８ ７ ６ ５ ４ ３ ２ １
            # +---------------------------+
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
            # | ・ ・ ・ ・ ・v玉 ・ ・ ・|二
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
            # | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
            # +---------------------------+
            # 先手の持駒：角　金四　銀二　歩九　

            Location.each do |e|
              if v = @header["#{e.name}の持駒"]
                mediator.player_at(e).pieces_set(v)
              end
            end

            mediator.board_reset(@board_source || header["手合割"])

            move_infos.each do |info|
              mediator.execute(info[:input])
            end
          end
        end

        def header_as_string
          @header_as_string ||= __header_as_string
        end

        private

        def __header_as_string
          out = ""

          obj = Mediator.new
          obj.board_reset(@board_source || header["手合割"])
          if v = obj.board.teai_name
            unless v == "平手"
              header["手合割"] = v
            end
            out << raw_header_as_string
          else
            header["後手の持駒"] ||= ""
            header["先手の持駒"] ||= ""
            out << raw_header_as_string.gsub(/(後手の持駒：.*\n)/, '\1' + obj.board.to_s)
          end

          out
        end

        def raw_header_as_string
          header.collect { |key, value|
            "#{key}：#{value}\n"
          }.join
        end

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

        def clock_exist?
          @clock_exist ||= @move_infos.any? {|e| e[:used_seconds].present? }
        end

        def used_seconds_at(index)
          @move_infos.dig(index, :used_seconds).to_i
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
