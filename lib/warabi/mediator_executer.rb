# frozen-string-literal: true

module Warabi
  concern :MediatorExecuter do
    included do
      attr_reader :hand_logs
      attr_accessor :kill_counter
    end

    def initialize(*)
      super

      @hand_logs = []
      @kill_counter = 0
    end

    # 棋譜入力
    def execute(str)
      Array.wrap(str).each do |str|

        # ▲△があれば見て手番と一致しているか確認する
        # なければチェックしなくていい
        if true
          if md = str.match(Runner.input_regexp)
            if key = md[:sankaku] || md[:plus_or_minus]
              location = Location.fetch(key)
              unless current_player.location == Location.fetch(key)
                raise DifferentTurnError, "#{current_player.call_name}番で#{reverse_player.call_name}が着手しました : #{str}"
              end
            end
          end
        end

        current_player.execute(str)
        turn_info.counter += 1
      end
    end

    # player.execute の直後に呼んで保存する
    def hand_log_push(player)
      @hand_logs << player.runner.hand_log
    end

    # 互換性用
    if true
      def kif_hand_logs; hand_logs.collect { |e| e.to_s_kif(with_mark: false) }; end
      def ki2_hand_logs; hand_logs.collect { |e| e.to_s_ki2(with_mark: true) }; end
    end

    def to_bod(**options)
      s = []
      s << player_at(:white).hold_pieces_snap + "\n"
      s << @board.to_s
      s << player_at(:black).hold_pieces_snap + "\n"

      last = ""
      if hand_log = hand_logs.last
        last = hand_log.to_s_kif(with_mark: true)
      end

      s << "手数＝#{turn_info.counter} #{last} まで".squish + "\n"

      # これいる？ → いる
      if true
        if current_player.location.key == :white # ← 判定が違う気がす
          s << "\n"
          s << "#{current_player.call_name}番\n"
        end
      end

      s.join
    end

    def to_s(*args)
      to_bod(*args)
    end

    def to_hand
      s = []
      s << @board.to_s
      s << @players.collect { |player|
        "#{player.call_name}の持駒:#{player.piece_box.to_s}"
      }.join("\n") + "\n"
      s.join
    end

    def judgment_message
      "まで#{turn_info.counter}手で#{win_player.call_name}の勝ち"
    end
  end
end
