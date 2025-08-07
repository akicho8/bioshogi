# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :AnalyzerMod do
      def execute_after_process
        player.used_soldier_counter.update(hand.used_soldier)
      end

      def move_hand_process
        super

        if move_hand.soldier.piece.key == :king
          # if move_hand.origin_soldier.king_default_place?
          #   # 元の位置から動いたか？
          # end
          player.king_moved_counter += 1 # 居玉判定用
          player.king_first_moved_turn ||= container.turn_info.turn_offset # 本当の居玉判定用
        end
      end

      def piece_box_added
        super

        if analysis_feature_enabled?
          # 総キル数の記録
          container.kill_count += 1
          player.kill_count += 1

          # 駒が取られる最初の手数の記録
          container.critical_turn ||= container.turn_info.turn_offset

          # 「歩と角」を除く駒が取られる最初の手数の記録
          unless container.outbreak_turn
            key = captured_soldier.piece.key
            if key != :pawn && key != :bishop
              container.outbreak_turn = container.turn_info.turn_offset
              CustomAnalyzer.new(self).call(:ct_outbreak)
            end
          end

          CustomAnalyzer.new(self).call(:ct_capture)
          CaptureAnalyzer.new(self).call
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
          ShapeAnalyzer.new(self).call
          MotionAnalyzer.new(self).call
          EveryAnalyzer.new(self).call
          MotionAnalyzer2.new(self).call
          CustomAnalyzer.new(self).call(:ct_every)
        end
      end

      def tag_bundle
        @tag_bundle ||= TagBundle.new
      end

      def analysis_feature_enabled?
        Bioshogi.config[:analysis_feature] && container.params[:analysis_feature] && Dimension.default_size?
      end
    end
  end
end
