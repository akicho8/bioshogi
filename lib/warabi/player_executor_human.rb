# frozen-string-literal: true

module Warabi
  class PlayerExecutorHuman < PlayerExecutorBase
    def piece_box_added
      mediator.kill_counter += 1
    end

    def turn_ended_process
      mediator.hand_logs << hand_log
    end

    def perform_skill_monitor
      if Warabi.config[:skill_monitor_enable]
        if Dimension.size_type == :board_size_9x9
          if mediator.params[:skill_monitor_enable]
            SkillMonitor.new(self).execute
          end
        end
      end
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :drop_hand    => @drop_hand,
          :move_hand      => @move_hand,
          :candidate      => @candidate_soldiers,
          :place_same     => place_same?,
          :skill_set      => skill_set,
        }).freeze
    end

    def skill_set
      @skill_set ||= SkillSet.new
    end

    def place_same?
      if hand_log = mediator.hand_logs.last
        hand_log.soldier.place == soldier.place
      end
    end
  end
end
