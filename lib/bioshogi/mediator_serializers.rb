module Bioshogi
  concern :MediatorSerializers do
    def judgment_message
      "まで#{turn_info.counter}手で#{win_player.call_name}の勝ち"
    end

    def to_s(*args)
      to_bod(*args)
    end

    concerning :KifMethods do
      def to_bod(**options)
        s = []
        s << player_at(:white).piece_box_as_header + "\n"
        s << board.to_s
        s << player_at(:black).piece_box_as_header + "\n"

        last = ""
        if respond_to?(:hand_logs)
          if hand_log = hand_logs.last
            last = hand_log.to_kif(with_location: true)
          end
        end

        s << "手数＝#{turn_info.counter} #{last} まで".squish + "\n"

        # if current_player.location.key == :white
        s << "\n"
        s << "#{current_player.call_name}番\n"
        # end

        s.join
      end

      def to_kif
        s = []
        s << board.to_s
        s << players.collect { |player|
          "#{player.call_name}の持駒:#{player.piece_box.to_s}"
        }.join("\n") + "\n"
        s.join
      end
    end

    concerning :CsaMethods do
      def to_csa(**options)
        s = []

        preset_info = board.preset_info

        if preset_info
          unless options[:oneline]
            s << "#{Parser::CsaParser.comment_char} 手合割:#{preset_info.name}" + "\n"
          end
        end

        if options[:board_expansion]
          s << board.to_csa
        else
          if preset_info&.key == :"平手"
            s << "PI" + "\n"
          else
            s << board.to_csa
          end
        end

        players.each do |player|
          if v = player.to_csa.presence
            s << v + "\n"
          end
        end

        s.join
      end
    end

    concerning :UsiMethods do
      attr_reader :initial_state_board_sfen
      attr_reader :initial_state_turn_info

      def initialize(*)
        super
        before_run_process            # FIXME
      end

      def before_run_process
        # turn_info_auto_set
        @initial_state_board_sfen = to_current_sfen # FIXME: これはイケてない
        @initial_state_turn_info = turn_info.clone
      end

      # 平手で開始する直前の状態か？
      def startpos?
        if e = board.preset_info
          e.key == :"平手" && players.all? { |e| e.piece_box.empty? }
        end
      end

      # 現在の局面
      def to_current_sfen
        if startpos?
          "startpos"
        else
          to_long_sfen
        end
      end

      def to_long_sfen
        (to_long_sfen_without_turn + [turn_info.turn_max.next]).join(" ")
      end

      def to_long_sfen_without_turn
        s = []
        s << "sfen"
        s << board.to_sfen
        s << turn_info.current_location.to_sfen
        if players.all? { |e| e.piece_box.empty? }
          s << "-"
        else
          s << players.collect(&:to_sfen).join
        end
        s
      end

      # 最初から現在までの局面
      def to_sfen(**options)
        s = []
        s << "position"
        s << @initial_state_board_sfen # 局面を文字列でとっておくのってなんか違う気がする
        if hand_logs.present?
          s << "moves"
          s.concat(hand_logs.collect(&:to_sfen))
        end
        s.join(" ")
      end
    end
  end
end
