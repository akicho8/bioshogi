module Bioshogi
  concern :MediatorSerializeMethods do
    def judgment_message
      "まで#{turn_info.display_turn}手で#{win_player.call_name}の勝ち"
    end

    def to_s(*args)
      to_bod(*args)
    end

    def to_bod(options = {})
      s = []
      s << player_at(:white).piece_box_as_header + "\n"
      s << board.to_s
      s << player_at(:black).piece_box_as_header + "\n"

      unless options[:display_turn_skip]
        last = ""
        if respond_to?(:hand_logs)
          if e = hand_logs.last
            last = e.to_kif(with_location: true)
          end
        end
        s << "手数＝#{turn_info.display_turn} #{last} まで".squish + "\n"
      end

      s << "#{current_player.call_name}番\n"
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

    def to_csa(options = {})
      s = []

      preset_info = board.preset_info

      if preset_info
        unless options[:oneline]
          s << "#{Parser::CsaParser::SYSTEM_COMMENT_CHAR} 手合割:#{preset_info.name}" + "\n"
        end
      end

      if options[:board_expansion]
        s << board.to_csa
      else
        if preset_info == PresetInfo.fetch("平手")
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

    def to_yomiage(options = {})
      MediatorSerializerCheckmateYomiage.new(self, options).to_s
    end

    def to_yomiage_list(options = {})
      MediatorSerializerCheckmateYomiage.new(self, options).to_a
    end

    concerning :SfenMethods do
      attr_reader :initial_state_board_sfen
      attr_reader :initial_state_turn_info

      def initialize(*)
        super
        before_run_process            # FIXME
      end

      def before_run_process
        # turn_info_auto_set
        @initial_state_board_sfen = to_short_sfen # FIXME: これはイケてない
        @initial_state_turn_info = turn_info.clone
      end

      # 平手で開始する直前の状態か？
      def startpos?
        if e = board.preset_info
          e.key == :"平手" && players.all? { |e| e.piece_box.empty? }
        end
      end

      # 現在の局面
      # def to_short_sfen
      #   if false
      #     if startpos?
      #       "position startpos"
      #     else
      #       to_short_sfen
      #     end
      #   else
      #     to_short_sfen
      #   end
      # end

      def to_short_sfen
        "#{to_short_sfen_without_turn} #{turn_info.display_turn.next}"
      end

      def to_short_sfen_without_turn
        s = []
        s << "position"
        s << "sfen"
        s << board.to_sfen
        s << turn_info.current_location.to_sfen
        if players.all? { |e| e.piece_box.empty? }
          s << "-"
        else
          s << players.collect(&:to_sfen).join
        end
        s.join(" ")
      end

      # 最初から現在までの局面
      def to_history_sfen(options = {})
        s = []
        unless @initial_state_board_sfen
          raise BioshogiError, "@initial_state_board_sfen が未定義"
        end
        s << @initial_state_board_sfen # 局面を文字列でとっておくのってなんか違う気がする
        if hand_logs.present?
          s << "moves"
          s.concat(hand_logs.collect(&:to_sfen))
        end
        s = s.join(" ")
        if options[:startpos_embed]
          s = Sfen.startpos_embed(s)
        end
        s
      end
    end
  end
end
