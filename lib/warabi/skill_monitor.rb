# frozen-string-literal: true

module Warabi
  class SkillMonitor
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def execute
      if e = TacticInfo.soldier_hash_table[soldier]
        e.each { |e| execute_one(e) }
      end
    end

    private

    def execute_one(e)
      catch :skip do
        # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
        list = player.skill_set.public_send(e.tactic_info.list_key)
        if list.include?(e)
          throw :skip
        end

        # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
        if e.cached_descendants.any? { |e| list.include?(e) }
          throw :skip
        end

        # 手数制限。制限を超えていたらskip
        if e.turn_limit
          if e.turn_limit < player.mediator.turn_info.counter.next
            throw :skip
          end
        end

        # 手数限定。手数が異なっていたらskip
        if e.turn_eq
          if e.turn_eq != player.mediator.turn_info.counter.next
            throw :skip
          end
        end

        # 手番限定。手番が異なればskip
        if e.order_key
          if e.order_key != player.mediator.turn_info.order_key
            throw :skip
          end
        end

        # 開戦済みならskip
        if e.cold_war
          if player.mediator.kill_counter.positive?
            throw :skip
          end
        end

        # 「打」時制限。移動元駒があればskip
        if e.direct_only
          if origin_soldier
            throw :skip
          end
        end

        # 駒を取ったとき制限。取ってないならskip
        if e.kill_only
          unless player.executor.killed_soldier
            throw :skip
          end
        end

        # 所持駒数一致制限。異なっていたらskip
        if v = e.hold_piece_empty
          if !player.piece_box.empty?
            throw :skip
          end
        end

        if true
          # 何もない制限。何かあればskip
          if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
            ary.each do |e|
              if surface[e[:point]]
                throw :skip
              end
            end
          end

          # 何かある制限。何もなければskip
          if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
            ary.each do |e|
              if !surface[e[:point]]
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
              if e[:point] == origin_soldier.point
                throw :skip
              end
            end
          end

          # 移動元である(any条件)。どの移動元にも該当しなかったらskip
          if points_hash = e.board_parser.other_objects_loc_points_hash[location.key]["★"]
            # 移動元がないということは、もう何も該当しないので skip
            unless origin_soldier
              throw :skip
            end
            if points_hash[origin_soldier.point]
              # 移動元があったのでOK
            else
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

        # 歩を除いて何か持っていたらskip
        if e.not_have_anything_except_pawn
          if !piece_box.except(:pawn).empty?
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
        if ary = e.board_parser.any_exist_soldiers_loc[location.key].presence
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

        list << e
        player.executor.skill_set.public_send(e.tactic_info.list_key) << e
      end
    end

    # 後手側の場合は先手側の座標に切り替え済み
    def soldier
      @soldier ||= player.executor.soldier.flip_if_white
    end

    # 比較順序超重要。不一致しやすいものから比較する
    def soldier_exist?(s)
      (v = surface[s.point]) && v.piece == s.piece && v.promoted == s.promoted && v.location == s.location
    end

    # 持駒
    def piece_box
      @piece_box ||= player.piece_box
    end

    # 移動元情報
    def origin_soldier
      @origin_soldier ||= player.executor.origin_soldier
    end

    # 盤面
    def surface
      @surface ||= player.board.surface
    end

    # プレイヤーの向き
    def location
      @location ||= player.location
    end
  end
end
