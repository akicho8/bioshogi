module Warabi
  concern :MediatorSerializers do
    concerning :CsaMethods do
      def to_csa(**options)
        s = []
        preset_name = board.preset_name
        if preset_name
          unless options[:oneline]
            s << "#{Parser::CsaParser.comment_char} 手合割:#{preset_name}" + "\n"
          end
        end
        if options[:board_expansion]
          s << board.to_csa
        else
          if preset_name == "平手"
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
      def initialize(*)
        super
        play_standby
      end

      def play_standby
        # turn_info_auto_set
        @first_state_board_sfen = to_current_sfen # FIXME: これはイケてない
      end

      # 平手で開始する直前の状態か？
      def startpos?
        board.preset_name == "平手" && players.all? { |e| e.pieces.empty? }
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
        # p turn_info
        s << turn_info.current_location.to_sfen
        if players.all? { |e| e.pieces.empty? }
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
