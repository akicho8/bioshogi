# frozen-string-literal: true

module Bushido
  class SkillMonitor
    attr_accessor :player

    def initialize(player)
      @player = player
    end

    def execute

      # soldiers = board.surface.values.find_all { |e| e.location == location }
      # sorted_black_side_mini_soldiers = soldiers.collect { |e| e.to_mini_soldier.reverse_if_white }.sort

      skip = Object.new
      check_items.each do |check_item|
        defense_infos = player.send(check_item[:varname])
        record = check_item[:model].find do |e|
          catch skip do
            if defense_infos.include?(e)
              throw skip
            end

            if e.turn_limit
              if e.turn_limit > player.mediator.turn_info.counter.next
                throw skip
              end
            end

            if e.only_location_key
              if e.only_location_key != player.location.key
                throw skip
              end
            end

            if e.turn_eq
              if e.turn_eq != player.mediator.turn_info.counter.next
                throw skip
              end
            end

            e.board_parser.other_objects.each do |oo|
              if oo[:something] == "○"
                pt = oo[:point].reverse_if_white(player.location)
                if player.board[pt]
                  throw skip
                end
              end
            end

            soldiers = player.board.surface.values
            mini_soldiers = soldiers.collect { |e| e.to_mini_soldier }

            if e.my_side_only
              mini_soldiers = mini_soldiers.find_all {|e| e[:location] == player.location }
            end

            if player.location.key == :white
              mini_soldiers = mini_soldiers.collect(&:reverse)
            end

            if e.compare_condition == "equal"
              # if e.my_side_only
              #   # 自分側だけで完全一致の場合
              #   # soldiers = player.board.surface.values
              #   # soldiers = soldiers.find_all { |e| e.location == player.location }
              #   # sorted_black_side_mini_soldiers = soldiers.collect { |e| e.to_mini_soldier.reverse_if_white }.sort
              mini_soldiers.sort == e.sorted_mini_soldiers
              # else
              # 相手側も見る場合

              # soldiers = player.board.surface.values
              # mini_soldiers = soldiers.collect { |e| e.to_mini_soldier }
              # if player.location.key == :white
              #   mini_soldiers = mini_soldiers.collect(&:reverse)
              # end
              # sorted_mini_soldiers = mini_soldiers.sort
              # sorted_mini_soldiers == e.shape_info.sorted_mini_soldiers
              # end
            elsif e.compare_condition == :include
              # 自分側だけで盤上の状態に含まれる？
              # e.black_side_mini_soldiers.all? do |e|
              #   if soldier = player.board[e[:point]]
              #     if soldier.location == player.location
              #       soldier.to_mini_soldier.reverse_if_white == e
              #     end
              #   end
              # end

              e.board_parser.mini_soldiers.all? { |e| mini_soldiers.include?(e) }

              # e.mini_soldiers.all? do |e|
              #   if soldier = player.board[e[:point]]
              #     if soldier.location == player.location
              #       soldier.to_mini_soldier.reverse_if_white == e
              #     end
              #   end
              # end
            else
              raise MustNotHappen
            end
          end
        end

        if record
          defense_infos << record
        end
      end

      # defense_info = DefenseInfo.find do |e|
      #   catch skip do
      #     if player.defense_infos.include?(e)
      #       next
      #     end
      #
      #     # 盤上の状態に含まれる？
      #     e.black_side_mini_soldiers.all? do |e|
      #       if soldier = player.mediator.board[e[:point]]
      #         if soldier.location == player.location
      #           soldier.to_mini_soldier.reverse_if_white == e
      #         end
      #       end
      #     end
      #   end
      # end

      # if defense_info
      #   player.defense_infos << defense_info
      # end

      # if true
      #   # soldiers = board.surface.values.find_all { |e| e.location == player.location }
      #   # sorted_black_side_mini_soldiers = soldiers.collect { |e| e.to_mini_soldier.reverse_if_white }.sort
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

    def check_items
      [
        {model: DefenseInfo, varname: :defense_infos, },
        {model: AttackInfo,  varname: :attack_infos,  },
      ]
    end
  end
end
