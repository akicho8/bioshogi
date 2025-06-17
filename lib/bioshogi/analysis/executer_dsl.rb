# frozen-string-literal: true

# executor メソッドに反応する (each に反応する Enumerable のように)

module Bioshogi
  module Analysis
    module ExecuterDsl
      delegate *[
        :player,                # 自分
        :drop_hand,             # 打った駒
        :move_hand,             # 移動した駒
        :soldier,               # 盤上で操作し終わった駒
        :origin_soldier,        # 移動元の駒
        :captured_soldier,
        :skill_set,
      ], to: :executor

      delegate *[
        :container,
        :opponent_player,
        :board,
        :location,
        :piece_box,
      ], to: :player

      def perform_block
        retv = false
        catch :skip do
          yield
          retv = true
        end
        retv
      end

      def and_cond
        unless yield
          throw :skip
        end
      end

      def break_cond
        if yield
          throw :skip
        end
      end

      def various_conditions(e)
        list = player.skill_set.list_of(e)

        ################################################################################ FIXME: 最初にチェックするのは遅いかもしれない

        # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
        if list.include?(e)
          throw :skip
        end

        # 「居飛車」判定のとき「振り飛車」がすでにあればスキップ
        if e.skip_if_exist.any? { |e| list.include?(e) }
          throw :skip
        end

        # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
        if e.cached_descendants.any? { |e| list.include?(e) }
          throw :skip
        end

        ################################################################################

        # 特定の初期配置でないならスキップ
        if v = e.preset_has
          unless executor.container.initial_preset_info&.public_send(v)
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
        if e.not_have_pawn
          if piece_box.has_key?(:pawn)
            throw :skip
          end
        end

        # # 歩を除いて何か持っていたらskip
        # if e. :pawn_have_ok
        #   unless piece_box.except(:pawn).empty?
        #     throw :skip
        #   end
        # end

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

      ################################################################################

      def cold_war_verification(e)
        # 開戦済みならskip
        # 例えばそれまで静かで始めて角交換したときは kill_count は 1 になるので outbreak_skip: nil, kill_count_lteq: 1 にしておけば skip されない
        # 0 < 1キル → skip
        # 1 < 1キル → ok
        if v = e.kill_count_lteq
          if v >= player.container.kill_count
          else
            throw :skip
          end
        end

        # 「歩と角」を除く駒が取られた場合はskip
        if e.outbreak_skip
          if player.container.outbreak_turn # 「歩と角」を除く駒が取られた手数が入っている
            throw :skip
          end
        end

        # 歩を除いて何か持っていたらskip
        if e.pawn_have_ok
          unless piece_box.except(:pawn).empty?
            throw :skip
          end
        end
      end

      # 盤上で操作し終わった駒の位置
      def place
        @place ||= soldier.place
      end

      # 後手側の場合は先手側の座標に切り替え済み
      def black_side_soldier
        @black_side_soldier ||= executor.soldier.white_then_flip
      end

      # 比較順序超重要。不一致しやすいものから比較する
      def soldier_exist?(s)
        if v = surface[s.place]
          v.piece == s.piece && v.promoted == s.promoted && v.location == s.location
        end
      end

      # place の位置に銀以上の価値がある(自分の)駒がある
      def worth_more_gteq_silver?(place)
        if v = surface[place]
          v.location == location && v.abs_weight >= silver_piece_basic_weight
        end
      end

      # place の位置に銀 or 金がある
      def silver_or_gold?(place)
        if v = surface[place]
          v.location == location && (v.piece.key == :silver || v.piece.key == :gold)
        end
      end

      # place の位置に歩以上の価値がある(自分の)駒がある
      def worth_more_gteq_pawn?(place)
        if v = surface[place]
          v.location == location
        end
      end

      # 銀の価値
      def silver_piece_basic_weight
        @silver_piece_basic_weight ||= Piece[:silver].basic_weight
      end

      # 相手の持駒
      def op_piece_box
        @op_piece_box ||= opponent_player.piece_box
      end

      # 盤面
      def surface
        @surface ||= board.surface
      end

      # soldier は相手の駒か？
      def opponent?(soldier)
        soldier.location == opponent_player.location
      end

      # soldier は自分の駒か？
      def own?(soldier)
        soldier.location == location
      end

      # 前より敵玉に近づいたか？
      # 半径を狭めないと近づいたことにならないので manhattan_distance_a_side_max を使うこと
      def move_to_op_king?
        opponent_player.king_soldier.place.then do |e|
          soldier.place.manhattan_distance_a_side_max(e) < origin_soldier.place.manhattan_distance_a_side_max(e)
        end
      end

      def skill_add(skill)
        player.skill_set.list_push(skill)
        skill_set.list_push(skill)

        if v = skill.add_to_self
          player.skill_set.list_push(v)
        end

        if v = skill.add_to_opponent
          player.opponent_player.skill_set.list_push(v)
        end
      end
    end
  end
end
