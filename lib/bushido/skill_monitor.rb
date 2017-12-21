# frozen-string-literal: true

module Bushido
  class SkillMonitor
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def execute
      execute_new
      # execute_old
    end

    def execute_new
      current_soldier = player.runner.current_soldier
      point = current_soldier.reverse_if_white.fetch(:point)
      target_elements = TacticInfo.all_soldier_points_hash[point] || []

      # p ["#{__FILE__}:#{__LINE__}", __method__, TacticInfo.all_soldier_points_hash.values.count]
      # p ["#{__FILE__}:#{__LINE__}", __method__, current_soldier.name]
      # p ["#{__FILE__}:#{__LINE__}", __method__, TacticInfo.all_soldier_points_hash.keys.collect(&:name)]
      # p ["#{__FILE__}:#{__LINE__}", __method__, point.name]
      # p ["#{__FILE__}:#{__LINE__}", __method__, TacticInfo.all_soldier_points_hash.keys.collect(&:name).include?(point.name)]
      # p ["#{__FILE__}:#{__LINE__}", __method__, target_elements.size]

      # p ["#{__FILE__}:#{__LINE__}", __method__, TacticInfo.all_soldier_points_hash.keys.first]
      # p ["#{__FILE__}:#{__LINE__}", __method__, point]
      # 
      # a = TacticInfo.all_soldier_points_hash.keys.first
      # b = point
      # 
      # p ["#{__FILE__}:#{__LINE__}", __method__, a.hash]
      # p ["#{__FILE__}:#{__LINE__}", __method__, b.hash]
      # p ["#{__FILE__}:#{__LINE__}", __method__, a.eql?(b)]
      # p ["#{__FILE__}:#{__LINE__}", __method__, a.to_a]
      # p ["#{__FILE__}:#{__LINE__}", __method__, b.to_a]

      # if point.name == "７六"
      #   raise
      # end

      target_elements.each do |e|
        # p ["#{__FILE__}:#{__LINE__}", __method__, e.key]

        tactic_info = e.tactic_info
        list = player.skill_set.public_send(tactic_info.var_key)
        catch :skip do
          # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
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

          if e.teban_eq
            if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
              throw :skip
            end
          end

          if e.kaisenmae
            if player.mediator.kill_counter.positive?
              throw :skip
            end
          end

          if e.stroke_only
            if player.runner.before_soldier
              throw :skip
            end
          end

          if e.kill_only
            unless player.runner.tottakoma
              throw :skip
            end
          end

          if v = e.hold_piece_count_eq
            if player.pieces.size != v
              throw :skip
            end
          end

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

          if e.fuganai
            if player.pieces.include?(Piece.fetch(:pawn))
              throw :skip
            end
          end

          if e.fu_igai_mottetara_dame
            unless (player.pieces - [Piece.fetch(:pawn)]).empty?
              throw :skip
            end
          end

          if v = e.hold_piece_eq
            if player.pieces.sort != v.sort
              throw :skip
            end
          end

          if v = e.hold_piece_in
            unless v.all? {|x| player.pieces.include?(x) }
              throw :skip
            end
          end

          if v = e.hold_piece_not_in
            if v.any? {|x| player.pieces.include?(x) }
              throw :skip
            end
          end

          if v = e.triggers
            current_soldier = player.runner.current_soldier
            if player.location.key == :white
              current_soldier = current_soldier.reverse
            end
            v.each do |soldier|
              if current_soldier != soldier
                throw :skip
              end
            end
          end

          # ここは位置のハッシュを作っておくのがいいかもしれん
          if v = e.board_parser.trigger_soldiers.presence
            current_soldier = player.runner.current_soldier
            if player.location.key == :white
              current_soldier = current_soldier.reverse
            end
            v.each do |soldier|
              if current_soldier != soldier
                throw :skip
              end
            end
          end

          soldiers = cached_board_soldiers(e)

          # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
          if v = e.gentei_match_any
            if v.any? {|o| soldiers.include?(o) }
            else
              throw :skip
            end
          end

          # どれかが盤上に含まれる
          if v = e.board_parser.any_exist_soldiers.presence
            if v.any? {|o| soldiers.include?(o) }
            else
              throw :skip
            end
          end

          if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
            list << e
            player.runner.skill_set.public_send(tactic_info.var_key) << e
          end
        end
      end
    end

    def execute_old
      TacticInfo.each do |tactic_info|
        list = player.skill_set.public_send(tactic_info.var_key)
        tactic_info.model.each do |e|
          catch :skip do
            # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
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

            if e.teban_eq
              if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
                throw :skip
              end
            end

            if e.kaisenmae
              if player.mediator.kill_counter.positive?
                throw :skip
              end
            end

            if e.stroke_only
              if player.runner.before_soldier
                throw :skip
              end
            end

            if e.kill_only
              unless player.runner.tottakoma
                throw :skip
              end
            end

            if v = e.hold_piece_count_eq
              if player.pieces.size != v
                throw :skip
              end
            end

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

            if e.fuganai
              if player.pieces.include?(Piece.fetch(:pawn))
                throw :skip
              end
            end

            if e.fu_igai_mottetara_dame
              unless (player.pieces - [Piece.fetch(:pawn)]).empty?
                throw :skip
              end
            end

            if v = e.hold_piece_eq
              if player.pieces.sort != v.sort
                throw :skip
              end
            end

            if v = e.hold_piece_in
              unless v.all? {|x| player.pieces.include?(x) }
                throw :skip
              end
            end

            if v = e.hold_piece_not_in
              if v.any? {|x| player.pieces.include?(x) }
                throw :skip
              end
            end

            if v = e.triggers
              current_soldier = player.runner.current_soldier
              if player.location.key == :white
                current_soldier = current_soldier.reverse
              end
              v.each do |soldier|
                if current_soldier != soldier
                  throw :skip
                end
              end
            end

            # ここは位置のハッシュを作っておくのがいいかもしれん
            if v = e.board_parser.trigger_soldiers.presence
              current_soldier = player.runner.current_soldier
              if player.location.key == :white
                current_soldier = current_soldier.reverse
              end
              v.each do |soldier|
                if current_soldier != soldier
                  throw :skip
                end
              end
            end

            soldiers = cached_board_soldiers(e)

            # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
            if v = e.gentei_match_any
              if v.any? {|o| soldiers.include?(o) }
              else
                throw :skip
              end
            end

            # どれかが盤上に含まれる
            if v = e.board_parser.any_exist_soldiers.presence
              if v.any? {|o| soldiers.include?(o) }
              else
                throw :skip
              end
            end

            if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
              list << e
              player.runner.skill_set.public_send(tactic_info.var_key) << e
            end
          end
        end
      end
    end

    def cached_board_soldiers(e)
      @cached_board_soldiers ||= -> {
        soldiers = player.board.surface.values.collect(&:to_soldier)
        if player.location.key == :white
          soldiers = soldiers.collect(&:reverse)
        end
        soldiers
      }.call
    end
  end
end
