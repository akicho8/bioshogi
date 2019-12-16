# frozen-string-literal: true

module Bioshogi
  class PlayerExecutorHuman < PlayerExecutorBase
    def move_hand_process(move_hand)
      super

      if move_hand.soldier.piece.key == :king
        player.king_moved_counter += 1 # 居玉判定用
      end
    end

    # 大駒コンプリートチェック用にしか使ってない
    def piece_box_added(captured_soldier)
      mediator.kill_counter += 1
      mediator.critical_turn ||= mediator.turn_info.counter # 開戦前手数

      if perform_skill_monitor_enable?
        TacticInfo.piece_box_added_proc_list.each do |e|
          if instance_exec(e, captured_soldier, &e.piece_box_added_proc)
            player.skill_set.list_push(e)
            skill_set.list_push(e)
          end
        end
      end
    end

    def turn_ended_process
      if v = @params[:used_seconds]
        player.personal_clock.add(v)
      end

      mediator.hand_logs << hand_log
    end

    def perform_skill_monitor
      if perform_skill_monitor_enable?
        SkillMonitor.new(self).execute
      end
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :drop_hand      => @drop_hand,
          :move_hand      => @move_hand,
          :candidate      => @candidate_soldiers,
          :place_same     => place_same?,
          :skill_set      => skill_set,
          :handicap       => mediator.turn_info.handicap?,
          :personal_clock => player.personal_clock.clone.freeze, # 時計の状態を保持して手に結びつける
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

    def perform_skill_monitor_enable?
      if Bioshogi.config[:skill_monitor_enable]
        if Dimension.size_type == :board_size_9x9
          mediator.params[:skill_monitor_enable]
        end
      end
    end
  end
end
