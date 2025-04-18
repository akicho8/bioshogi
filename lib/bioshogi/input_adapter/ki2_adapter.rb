# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    class Ki2Adapter < KifAdapter
      def self.flip_table
        @flip_table ||= yield_self do
          table = { :first => :last, :> => :< }
          table.merge(table.invert)
        end
      end

      include Ki2MotionWrapper

      # 移動元候補がない場合は打が省略されている
      def drop_trigger
        super || drop_abbreviation?
      end

      def place_from
        @place_from ||= yield_self do
          if soldier = origin_soldier
            soldier.place
          end
        end
      end

      def hard_validations
        super

        if !drop_trigger && candidate_soldiers.size >= 2 && motion_str.empty?
          errors_add AmbiguousFormatError, "#{place}に移動できる駒が#{candidate_soldiers.size}つありますが表記が曖昧なため特定できません。#{candidate_soldiers_as_string}"
        end

        if !drop_trigger && candidate_soldiers.count >= 2 && !place_from
          errors_add AmbiguousFormatError, "#{place}に移動できる駒が#{candidate_soldiers.size}つありますが「#{motion_str}」からは特定できません。#{candidate_soldiers_as_string}"
        end

        if force_drop_trigger && !player.piece_box.exist?(piece)
          errors_add HoldPieceNotFound, "打を明示しましたが#{piece}を持っていません"
        end

        if drop_abbreviation? && !player.piece_box.exist?(piece)
          message = []
          message << "#{place}に移動できる#{piece}がないため打の省略形と考えましたが#{piece}を持っていません"
          message += turn_error_messages
          message = message.join("。")
          errors_add HoldPieceNotFound2, message
        end

        if !drop_trigger && candidate_soldiers.empty?
          message = []
          message << "#{player.call_name}の手番で#{place}に移動できる#{input[:kif_piece]}が見つかりません"
          if promoted
            message << "「#{place}#{piece}成」の間違いかもしれません"
          end
          message += turn_error_messages
          message = message.join("。")
          errors_add MovableBattlerNotFound, message
        end

        if drop_trigger && promoted
          errors_add IllegibleFormat, "成・不成と打が干渉しています"
        end
      end

      def origin_soldier
        @origin_soldier ||= yield_self do
          unless force_drop_trigger
            v = candidate_soldiers_select
            if v.size == 1
              v.first
            end
          end
        end
      end

      private

      def candidate_soldiers_select
        @candidate_soldiers_select ||= yield_self do
          list = candidate_soldiers

          if list.size >= 2
            if v = left_right
              if md = v.match(/[左右]/)
                if piece.brave?
                  m = { "左" => :first, "右" => :last }.fetch(md.to_s)
                  m = white_then_flip(m)
                  list = list.sort_by { |e| e.place.column.value }.send(m, 1)
                else
                  m = { "左" => :>, "右" => :< }.fetch(md.to_s)
                  m = white_then_flip(m)
                  list = list.find_all do |e|
                    place.column.value.send(m, e.place.column.value)
                  end
                end
              end
            end
          end

          if list.size >= 2
            if v = up_down
              if md = v.match(/[上引]/)
                m = { "上" => :<, "引" => :> }.fetch(md.to_s)
                m = white_then_flip(m)
                list = list.find_all do |e|
                  place.row.value.send(m, e.place.row.value)
                end
              end
            end
          end

          # 竜が1つだけで１５の竜が５５に来たときも「１五竜寄」なので左右1マスの限定のチェックは入れてはいけない
          if list.size >= 2
            if v = up_down
              if v.include?("寄")
                list = list.find_all { |e| e.place.row == place.row }
              end
            end
          end

          # 真下にあるもの
          if list.size >= 2
            if one_up?
              y = place.row.value + player.location.which_value(1, -1)
              list = list.find_all { |e|
                e.place.column == place.column && e.place.row.value == y
              }
            end
          end

          list
        end
      end

      # 「打」の省略形かを推測する
      #
      #  1. 駒が成っていないこと
      #  2. 同・左右・打などのサフィックスがないこと
      #  3. 指定の位置に来れる駒がないこと
      #
      def drop_abbreviation?
        !promoted && !suffix_exist? && candidate_soldiers.empty?
      end

      def white_then_flip(key)
        if player.location.key == :white
          key = self.class.flip_table[key]
        end
        key
      end
    end
  end
end
