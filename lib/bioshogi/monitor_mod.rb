# frozen-string-literal: true

module Bioshogi
  concern :MonitorMod do
    def move_hand_process(move_hand)
      super

      if move_hand.soldier.piece.key == :king
        player.king_moved_counter += 1 # 居玉判定用
      end
    end

    # 大駒コンプリートチェック用にしか使ってない
    def piece_box_added(captured_soldier)
      # 駒を取った回数の記録
      mediator.kill_counter += 1

      # 駒が取られる最初の手数の記録
      mediator.critical_turn ||= mediator.turn_info.turn_offset

      # 「歩と角」を除く駒が取られる最初の手数の記録
      unless mediator.outbreak_turn
        key = captured_soldier.piece.key
        if key != :pawn && key != :bishop
          mediator.outbreak_turn = mediator.turn_info.turn_offset
        end
      end

      if perform_skill_monitor_enable?
        TacticInfo.piece_box_added_proc_list.each do |e|
          if instance_exec(e, captured_soldier, &e.piece_box_added_proc)
            player.skill_set.list_push(e)
            skill_set.list_push(e)
          end
        end
      end
    end

    def clock_add_process
      super

      if v = @params[:used_seconds]
        player.personal_clock.add(v)
      end
    end

    def perform_skill_monitor
      if perform_skill_monitor_enable?
        SkillMonitor.new(self).execute
      end
    end

    def skill_set
      @skill_set ||= SkillSet.new
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
