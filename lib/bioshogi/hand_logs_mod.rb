# frozen-string-literal: true

module Bioshogi
  concern :HandLogsMod do
    def turn_ended_process
      super

      container.hand_logs << hand_log
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :drop_hand          => @drop_hand,
          :move_hand          => @move_hand,
          :candidate_soldiers => @candidate_soldiers, # nil の場合もある
          :place_same         => place_same?,
          :tag_bundle          => tag_bundle,
          :handicap           => container.turn_info.handicap?,
          :single_clock       => player.single_clock.clone.freeze, # 時計の状態を保持して手に結びつける
        }).freeze
    end

    def place_same?
      if hand_log = container.hand_logs.last
        hand_log.soldier.place == soldier.place
      end
    end
  end
end
