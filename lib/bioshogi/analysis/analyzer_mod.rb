# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :AnalyzerMod do
      def execute_after_process
        player.used_piece_counts[hand.to_counts_key] += 1
      end

      def move_hand_process(move_hand)
        super

        if move_hand.soldier.piece.key == :king
          # if move_hand.origin_soldier.king_default_place?
          #   # 元の位置から動いたか？
          # end
          player.king_moved_counter += 1 # 居玉判定用
          player.king_first_moved_turn ||= container.turn_info.turn_offset # 本当の居玉判定用
        end
      end

      # 大駒コンプリートチェック用にしか使ってない、ことはない
      def piece_box_added(captured_soldier)
        # 駒を取った回数の記録
        container.kill_count += 1

        # 駒が取られる最初の手数の記録
        container.critical_turn ||= container.turn_info.turn_offset

        # 「歩と角」を除く駒が取られる最初の手数の記録
        unless container.outbreak_turn
          key = captured_soldier.piece.key
          if key != :pawn && key != :bishop
            container.outbreak_turn = container.turn_info.turn_offset
          end
        end

        if analysis_feature_enabled?
          TacticInfo.piece_box_added_proc_list.each do |e|
            if instance_exec(e, captured_soldier, &e.piece_box_added_proc)
              skill_push2(e)
            end
          end
        end
      end

      def clock_add_process
        super

        if v = @params[:used_seconds]
          player.single_clock.add(v)
        end
      end

      def perform_analyzer
        if analysis_feature_enabled?
          Analyzer.new(self).call
        end
      end

      def skill_push2(skill)
        player.skill_set.list_push(skill)   # プレイヤーの個別設定
        skill_set.list_push(skill) # executor の方にも設定(これいる？) ← いらない

        # 自分に入れる
        # p skill
        # p skill.add_to_self
        if v = skill.add_to_self
          player.skill_set.list_push(v)
        end

        # 相手に入れる
        if v = skill.add_to_opponent
          player.opponent_player.skill_set.list_push(v)
          # 設計ミス
          # skill_set.list_push(v) # ← しかし、ここで入れてしまうと 先手に後手の技が入ってしまう。つまり先後の情報を含める。
        end
      end

      def skill_set
        @skill_set ||= SkillSet.new
      end

      def analysis_feature_enabled?
        Bioshogi.config[:analysis_feature] && container.params[:analysis_feature] && Dimension.default_size?
      end
    end
  end
end
