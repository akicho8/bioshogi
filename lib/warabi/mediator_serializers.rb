module Warabi
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
        s << @board.to_s
        s << player_at(:black).piece_box_as_header + "\n"

        last = ""
        if hand_log = hand_logs.last
          last = hand_log.to_kif(with_location: true)
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
        s << @board.to_s
        s << @players.collect { |player|
          "#{player.call_name}の持駒:#{player.piece_box.to_s}"
        }.join("\n") + "\n"
        s.join
      end
    end

    concerning :CsaMethods do
      def to_csa(**options)
        s = []

        preset_key = board.preset_key

        if preset_key
          unless options[:oneline]
            s << "#{Parser::CsaParser.comment_char} 手合割:#{preset_key}" + "\n"
          end
        end

        if options[:board_expansion]
          s << board.to_csa
        else
          if preset_key == :"平手"
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
      attr_reader :first_state_board_sfen

      def initialize(*)
        super
        play_standby            # FIXME
      end

      def play_standby
        # turn_info_auto_set
        @first_state_board_sfen = to_current_sfen # FIXME: これはイケてない
      end

      # 平手で開始する直前の状態か？
      def startpos?
        board.preset_key == :"平手" && players.all? { |e| e.piece_box.empty? }
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
        s = []
        s << "sfen"
        s << board.to_sfen
        s << turn_info.current_location.to_sfen
        if players.all? { |e| e.piece_box.empty? }
          s << "-"
        else
          s << players.collect(&:to_sfen).join
        end
        s << turn_info.counter.next
        s.join(" ")
      end

      # 最初から現在までの局面
      def to_sfen(**options)
        s = []
        s << "position"
        s << @first_state_board_sfen # 局面を文字列でとっておくのってなんか違う気がする
        if hand_logs.present?
          s << "moves"
          s.concat(hand_logs.collect(&:to_sfen))
        end
        s.join(" ")
      end
    end
  end
end
