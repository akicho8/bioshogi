# frozen-string-literal: true

module Bushido
  class SkillMonitor
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def execute
      skip = Object.new
      SkillGroupInfo.each do |group|
        list = player.skill_set.public_send(group.var_key)
        group.model.each do |e|
          hit_flag = nil
          catch skip do
            # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
            if list.include?(e)
              throw skip
            end

            # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
            if e.cached_descendants.any? { |e| list.include?(e) }
              throw skip
            end

            if e.turn_limit
              if e.turn_limit < player.mediator.turn_info.counter.next
                throw skip
              end
            end

            if e.turn_eq
              if e.turn_eq != player.mediator.turn_info.counter.next
                throw skip
              end
            end

            if e.teban_eq
              if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
                throw skip
              end
            end

            if e.kaisenmae
              if player.mediator.kill_counter.positive?
                throw skip
              end
            end

            if e.stroke_only
              if player.runner.before_soldier
                throw skip
              end
            end

            if e.kill_only
              unless player.runner.tottakoma
                throw skip
              end
            end

            if v = e.hold_piece_count_eq
              if player.pieces.size != v
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
            if v = e.board_parser.other_objects.find_all { |e| e[:something] == "★" }.presence
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

            if e.fuganai
              if player.pieces.include?(Piece[:pawn])
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
              soldiers = soldiers.find_all { |e| e[:location] == player.location }
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
              hit_flag = (soldiers.sort == e.sorted_soldiers)
            elsif e.compare_condition == :include
              hit_flag = e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
            else
              raise MustNotHappen
            end

            if hit_flag
              list << e
              player.runner.skill_set.public_send(group.var_key) << e
            end
          end
        end
      end
    end
  end
end
