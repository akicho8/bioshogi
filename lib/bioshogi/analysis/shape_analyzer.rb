# frozen-string-literal: true

module Bioshogi
  module Analysis
    class ShapeAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        if e = TagIndex.shape_trigger_table[black_side_soldier]
          e.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            retv = perform_block do
              various_conditions(e)
              if e.shape_detector
                instance_exec(&e.shape_detector.func)
              end
            end
            if retv
              tag_add(e)
            end
          end
        end
      end

      def various_conditions(e)
        # すでに持っていればスキップ
        if player.tag_bundle.include?(e)
          throw :skip
        end

        ################################################################################

        # 特定の初期配置でないならスキップ
        if v = e.preset_has
          unless preset_is(v)
            throw :skip
          end
        end

        ################################################################################

        # 手数制限。制限を超えていたらskip
        if e.turn_limit
          if e.turn_limit < player.container.turn_info.display_turn.next
            throw :skip
          end
        end

        # 手数限定。手数が異なっていたらskip
        if e.turn_eq
          if e.turn_eq != player.container.turn_info.display_turn.next
            throw :skip
          end
        end

        # 手番限定。手番が異なればskip
        if e.order_key
          if e.order_key != player.container.turn_info.order_key
            throw :skip
          end
        end

        # 開戦済みならskip
        cold_war_verification(e)

        # 「打」時制限。移動元駒があればskip
        if e.drop_only
          if origin_soldier
            throw :skip
          end
        end

        # 駒を取ったとき制限。取ってないならskip
        if e.kill_only
          unless captured_soldier
            throw :skip
          end
        end

        # 駒を持っていないこと。異なっていたらskip
        if v = e.hold_piece_empty
          unless player.piece_box.empty?
            throw :skip
          end
        end

        if true
          # 何もない制限。何かあればskip
          if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
            ary.each do |e|
              if surface[e[:place]]
                throw :skip
              end
            end
          end

          # 何かある制限。何もなければskip
          if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
            ary.each do |e|
              unless surface[e[:place]]
                throw :skip
              end
            end
          end
        end

        if true
          # 移動元ではない制限。移動元だったらskip
          if ary = e.board_parser.other_objects_loc_ary[location.key]["☆"]
            # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
            unless origin_soldier
              throw :skip
            end
            ary.each do |e|
              if e[:place] == origin_soldier.place
                throw :skip
              end
            end
          end

          # 移動元である(any条件)。どの移動元にも該当しなかったらskip
          if places_hash = e.board_parser.other_objects_loc_places_hash[location.key]["★"]
            # 移動元がないということは、もう何も該当しないので skip
            unless origin_soldier
              throw :skip
            end
            if places_hash[origin_soldier.place]
              # 移動元があったのでOK
            else
              throw :skip
            end
          end
        end

        # 自分の金or銀以上がある
        if ary = e.board_parser.other_objects_loc_ary[location.key]["◆"]
          ary.each do |e|
            unless worth_more_gteq_silver?(e[:place])
              throw :skip
            end
          end
        end

        # 自分の金or銀がある
        if ary = e.board_parser.other_objects_loc_ary[location.key]["■"]
          ary.each do |e|
            unless silver_or_gold?(e[:place])
              throw :skip
            end
          end
        end

        # 自分の金or銀がない
        if ary = e.board_parser.other_objects_loc_ary[location.key]["□"]
          ary.each do |e|
            if silver_or_gold?(e[:place])
              throw :skip
            end
          end
        end

        # 自分の歩以上の駒がある
        if ary = e.board_parser.other_objects_loc_ary[location.key]["◇"]
          ary.each do |e|
            unless worth_more_gteq_pawn?(e[:place])
              throw :skip
            end
          end
        end

        # 歩を持っていたらskip
        if e.has_pawn_then_skip
          if piece_box.has_key?(:pawn)
            throw :skip
          end
        end

        if true
          # 駒が一致していなければskip
          if v = e.hold_piece_eq
            if piece_box != v
              throw :skip
            end
          end

          # 相手の駒が一致していなければskip
          if v = e.op_hold_piece_eq
            if op_piece_box != v
              throw :skip
            end
          end

          # 指定の駒をすべて含んでいるならOK
          if v = e.hold_piece_in
            if v.all? { |piece_key, _| piece_box.has_key?(piece_key) }
            else
              throw :skip
            end
          end

          # 指定の駒をどれか含んでいるならskip
          if v = e.hold_piece_not_in
            if v.any? { |piece_key, _| piece_box.has_key?(piece_key) }
              throw :skip
            end
          end
        end

        # どれかが盤上に正確に含まれるならOK
        if ary = e.board_parser.black_any_exist_soldiers.location_adjust[location.key].presence
          if ary.any? { |e| soldier_exist?(e) }
          else
            throw :skip
          end
        end

        # どれかが盤上に正確に含まれるならOK
        if ary = e.board_parser.white_any_exist_soldiers.location_adjust[location.key].presence
          if ary.any? { |e| soldier_exist?(e) }
          else
            throw :skip
          end
        end

        # 指定の配置が盤上に含まれるならOK
        ary = e.board_parser.location_adjust[location.key]
        if ary.all? { |e| soldier_exist?(e) }
        else
          throw :skip
        end

        # 先手でどれかが盤上に正確に含まれたらskip (for 流線矢倉)
        if ary = e.board_parser.black_not_exist_soldiers.location_adjust[location.key].presence
          if ary.any? { |e| soldier_exist?(e) }
            throw :skip
          end
        end

        # 後手でどれかが盤上に正確に含まれたらskip
        if ary = e.board_parser.white_not_exist_soldiers.location_adjust[location.key].presence
          if ary.any? { |e| soldier_exist?(e) }
            throw :skip
          end
        end
      end
    end
  end
end
