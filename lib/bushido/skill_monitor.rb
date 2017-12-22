# frozen-string-literal: true

module Bushido
  class SkillMonitor
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def execute
      elements = TacticInfo.soldier_hash_table[current_soldier] || []
      elements.each { |e| execute_one(e) }
    end

    def execute_one(e)
      catch :skip do
        # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
        list = player.skill_set.public_send(e.tactic_info.var_key)
        if list.include?(e)
          throw :skip
        end

        # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
        if e.cached_descendants.any? { |e| list.include?(e) }
          throw :skip
        end

        if e.turn_limit
          if e.turn_limit < player.mediator.turn_info.counter.next
            throw :skip
          end
        end

        if e.turn_eq
          if e.turn_eq != player.mediator.turn_info.counter.next
            throw :skip
          end
        end

        if e.order_key
          if e.order_key != player.mediator.turn_info.order_key
            throw :skip
          end
        end

        if e.cold_war
          if player.mediator.kill_counter.positive?
            throw :skip
          end
        end

        if e.stroke_only
          if before_soldier
            throw :skip
          end
        end

        if e.kill_only
          unless player.runner.killed_piece
            throw :skip
          end
        end

        if v = e.hold_piece_count_eq
          if player.pieces.size != v
            throw :skip
          end
        end

        if true
          # 何もない
          if ary = e.board_parser.other_objects_hash2[player.location.key]["○"]
            ary.each do |v|
              if surface[v]
                throw :skip
              end
            end
          end
          # 何かある
          if ary = e.board_parser.other_objects_hash2[player.location.key]["●"]
            ary.each do |e|
              if !surface[e[:point]]
                throw :skip
              end
            end
          end

          # 移動元ではない
          if ary = e.board_parser.other_objects_hash2[player.location.key]["☆"]
            # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
            unless before_soldier
              throw :skip
            end
            ary.each do |e|
              if e[:point] == before_soldier.point
                throw :skip
              end
            end
          end

          # 移動元(any条件)
          if points_hash = e.board_parser.other_objects_hash3[player.location.key]["★"]
            # 移動元がないということは、もう何も該当しないので skip
            unless before_soldier
              throw :skip
            end
            if points_hash[before_soldier.point]
              # 移動元があったのでOK
            else
              throw :skip
            end
          end
        else
          # 何もない
          if ary = e.board_parser.other_objects_hash_ary["○"]
            ary.each do |obj|
              pt = obj[:point].reverse_if_white(player.location)
              if player.board[pt]
                throw :skip
              end
            end
          end

          # 何かある
          if ary = e.board_parser.other_objects_hash_ary["●"]
            ary.each do |obj|
              pt = obj[:point].reverse_if_white(player.location)
              if !player.board[pt]
                throw :skip
              end
            end
          end

          # 移動元ではない
          if ary = e.board_parser.other_objects_hash_ary["☆"]
            ary.each do |obj|
              pt = obj[:point].reverse_if_white(player.location)
              before_soldier = player.runner.before_soldier
              if before_soldier && pt == before_soldier.point
                throw :skip
              end
            end
          end

          # 移動元(any条件)
          ary = e.board_parser.other_objects_hash_ary["★"]
          if ary.present?
            before_soldier = player.runner.before_soldier
            if !before_soldier
              # 移動元がないということは、もう何も該当しないので skip
              throw :skip
            end
            if ary.any? { |e|
                pt = e[:point].reverse_if_white(player.location)
                pt == before_soldier.point
              }
            else
              throw :skip
            end
          end

        end

        if e.not_have_pawn
          if player_pieces_sort_hash.has_key?(Piece.fetch(:pawn))
            throw :skip
          end
        end

        if e.not_have_anything_except_pawn
          unless (player_pieces_sort - [Piece.fetch(:pawn)]).empty?
            throw :skip
          end
        end

        if v = e.hold_piece_eq
          if player_pieces_sort != v
            throw :skip
          end
        end

        # 指定の駒をすべて持っているならOK
        if v = e.hold_piece_in
          if v.all? {|x| player_pieces_sort_hash.has_key?(x) }
          else
            throw :skip
          end
        end

        # 指定の駒をどれか持っていたらskip
        if v = e.hold_piece_not_in
          if v.any? {|x| player_pieces_sort_hash.has_key?(x) }
            throw :skip
          end
        end

        if true
          # どれかが盤上に含まれる(駒の一致も確認)
          if ary = e.board_parser.other_objects_hash4[player.location.key].presence
            if ary.any? { |e| on_board_soldiers3(e) }
            else
              throw :skip
            end
          end

        else
          # どれかが盤上に含まれる
          soldiers = on_board_soldiers(e)
          if v = e.board_parser.any_exist_soldiers.presence
            if v.any? {|o| soldiers.include?(o) } # FIXME: hashにする
            else
              throw :skip
            end
          end
        end

        if true
          ary = e.board_parser.soldiers_hash2[player.location.key]
          # if ary.all? { |e| on_board_soldiers2.include?(e) }
          if ary.all? { |e| on_board_soldiers3(e) }
          else
            throw :skip
          end

          list << e
          player.runner.skill_set.public_send(e.tactic_info.var_key) << e

        else
          soldiers = on_board_soldiers(e)
          if e.board_parser.soldiers.all? { |e| soldiers.include?(e) } # FIXME: hashにする
            list << e
            player.runner.skill_set.public_send(e.tactic_info.var_key) << e
          end
        end
      end
    end

    # 後手側の場合は先手側の座標に切り替え済み
    def current_soldier
      @current_soldier ||= player.runner.current_soldier.reverse_if_white
    end

    # def on_board_soldiers(e)
    #   @on_board_soldiers ||= -> {
    #     soldiers = surface.values.collect(&:to_soldier)
    #     # 後手ならまるごと反転する
    #     if player.location.key == :white
    #       soldiers = soldiers.collect(&:reverse)
    #     end
    #     soldiers
    #   }.call
    # end

    # def on_board_soldiers2
    #   @on_board_soldiers2 ||= surface.values.collect(&:to_soldier)
    # end

    # 比較順序超重要
    def on_board_soldiers3(s)
      (v = surface[s[:point]]) && v.piece == s[:piece] && v.promoted == s[:promoted] && v.location == s[:location]
    end

    # ["歩", "飛", "歩"] => ["飛", "歩", "歩"]
    def player_pieces_sort
      @player_pieces_sort ||= player.pieces.sort
    end

    # ["歩", "歩", "歩"] => {"歩" => 3}
    def player_pieces_sort_hash
      @player_pieces_sort_hash ||= player_pieces_sort.group_by(&:itself).transform_values(&:size)
    end

    def before_soldier
      @before_soldier ||= player.runner.before_soldier
    end

    def surface
      @surface ||= player.board.surface
    end
  end
end
