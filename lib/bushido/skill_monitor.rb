# frozen-string-literal: true

module Bushido
  class SkillMonitor
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def execute

      # battlers = board.surface.values.find_all { |e| e.location == location }
      # sorted_black_side_soldiers = battlers.collect { |e| e.to_soldier.reverse_if_white }.sort

      skip = Object.new
      skill_models.each do |check_item|
        infos = player.send(check_item[:var_key])
        info_keys = infos.collect(&:key)
        check_item[:model].each do |e|
          hit_flag = nil
          catch skip do
            if infos.include?(e)
              throw skip
            end

            if v = e.evolution_keys
              if v.any? {|e| info_keys.include?(e) }
                throw skip
              end
            end

            if e.turn_limit
              if player.mediator.turn_info.counter.next > e.turn_limit
                throw skip
              end
            end

            if e.junban_eq
              if e.junban_eq == player.mediator.turn_info.senteban_or_goteban
              else
                throw skip
              end
            end

            if e.turn_eq
              if e.turn_eq != player.mediator.turn_info.counter.next
                throw skip
              end
            end

            e.board_parser.other_objects.each do |obj|
              # 何もない
              if obj[:something] == "○"
                pt = obj[:point].reverse_if_white(player.location)
                if player.board[pt]
                  throw skip
                end
              end

              # 何かある
              if obj[:something] == "●"
                pt = obj[:point].reverse_if_white(player.location)
                if !player.board[pt]
                  throw skip
                end
              end

              # 移動元ではない
              if obj[:something] == "☆"
                pt = obj[:point].reverse_if_white(player.location)
                if (before_soldier = player.runner.before_soldier) && pt == before_soldier.point
                  throw skip
                else
                end
              end
            end

            # 移動元(any条件)
            if v = e.board_parser.other_objects.find_all{|e|e[:something] == "★"}.presence
              if v.any? {|e|
                  pt = e[:point].reverse_if_white(player.location)
                  if before_soldier = player.runner.before_soldier
                    pt == before_soldier.point
                  end
                }
              else
                throw skip
              end
            end

            if e.kaisenmae
              if player.mediator.kill_counter.positive?
                throw skip
              end
            end

            if e.uttatokidake
              if player.runner.before_soldier
                throw skip
              end
            end

            if e.tottatokidake
              unless player.runner.tottakoma
                throw skip
              end
            end

            if e.fuganai
              if player.pieces.include?(Piece[:pawn])
                throw skip
              end
            end

            if v = e.hold_piece_count_eq
              if player.pieces.size != v
                throw skip
              end
            end

            if v = e.hold_piece_eq
              if player.pieces.sort != v.sort
                throw skip
              end
            end

            if v = e.hold_piece_in
              unless v.all? {|x| player.pieces.include?(x) }
                throw skip
              end
            end

            if v = e.hold_piece_not_in
              if v.any? {|x| player.pieces.include?(x) }
                throw skip
              end
            end

            if v = e.triggers
              current_soldier = player.runner.current_soldier
              if player.location.key == :white
                current_soldier = current_soldier.reverse
              end
              v.each do |soldier|
                if current_soldier != soldier
                  throw skip
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
                  throw skip
                end
              end
            end

            battlers = player.board.surface.values
            soldiers = battlers.collect { |e| e.to_soldier }

            if e.compare_my_side_only
              soldiers = soldiers.find_all {|e| e[:location] == player.location }
            end

            if player.location.key == :white
              soldiers = soldiers.collect(&:reverse)
            end

            # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
            if v = e.gentei_match_any
              if v.any? {|o| soldiers.include?(o) }
              else
                throw skip
              end
            end

            # どれかが盤上に含まれる
            if v = e.board_parser.any_exist_soldiers.presence
              if v.any? {|o| soldiers.include?(o) }
              else
                throw skip
              end
            end

            if e.compare_condition == :equal
              # if e.compare_my_side_only
              #   # 自分側だけで完全一致の場合
              #   # battlers = player.board.surface.values
              #   # battlers = battlers.find_all { |e| e.location == player.location }
              #   # sorted_black_side_soldiers = battlers.collect { |e| e.to_soldier.reverse_if_white }.sort
              hit_flag = soldiers.sort == e.sorted_soldiers
              # else
              # 相手側も見る場合

              # battlers = player.board.surface.values
              # soldiers = battlers.collect { |e| e.to_soldier }
              # if player.location.key == :white
              #   soldiers = soldiers.collect(&:reverse)
              # end
              # sorted_soldiers = soldiers.sort
              # sorted_soldiers == e.shape_info.sorted_soldiers
              # end
            elsif e.compare_condition == :include
              # 自分側だけで盤上の状態に含まれる？
              # e.black_side_soldiers.all? do |e|
              #   if battler = player.board[e[:point]]
              #     if battler.location == player.location
              #       battler.to_soldier.reverse_if_white == e
              #     end
              #   end
              # end

              hit_flag = e.board_parser.soldiers.all? { |e| soldiers.include?(e) }

              # e.soldiers.all? do |e|
              #   if battler = player.board[e[:point]]
              #     if battler.location == player.location
              #       battler.to_soldier.reverse_if_white == e
              #     end
              #   end
              # end
            else
              raise MustNotHappen
            end

            if hit_flag
              infos << e
              player.runner.public_send(check_item[:var_key]) << e
            end
          end
        end
      end

      # defense_info = DefenseInfo.find do |e|
      #   catch skip do
      #     if player.infos.include?(e)
      #       next
      #     end
      #
      #     # 盤上の状態に含まれる？
      #     e.black_side_soldiers.all? do |e|
      #       if battler = player.mediator.board[e[:point]]
      #         if battler.location == player.location
      #           battler.to_soldier.reverse_if_white == e
      #         end
      #       end
      #     end
      #   end
      # end

      # if defense_info
      #   player.infos << defense_info
      # end

      # if true
      #   # battlers = board.surface.values.find_all { |e| e.location == player.location }
      #   # sorted_black_side_soldiers = battlers.collect { |e| e.to_soldier.reverse_if_white }.sort
      #
      #   attack_info = AttackInfo.find do |e|
      #     if player.attack_infos.include?(e)
      #       next
      #     end
      #
      #   end
      #
      #   if attack_info
      #     player.attack_infos << attack_info
      #   end
      # end
    end

    private

    def skill_models
      [
        {model: DefenseInfo, var_key: :defense_infos, },
        {model: AttackInfo,  var_key: :attack_infos,  },
      ]
    end
  end
end
