# frozen-string-literal: true

module Warabi
  module InputAdapter
    class Ki2Adapter < KifAdapter
      def self.flip_table
        @flip_table ||= -> {
          table = {:first => :last, :> => :<}
          table.merge(table.invert)
        }.call
      end

      include Ki2MotionWrapper

      # 移動元候補がない場合は打が省略されている
      def direct_trigger
        super || direct_abbreviation?
      end

      def point_from
        @point_from ||= -> {
          if soldier = origin_soldier
            soldier.point
          end
        }.call
      end

      def hard_validations
        super

        if !direct_trigger && candidate_soldiers.size >= 2 && motion_str.empty?
          errors_add AmbiguousFormatError, "#{point}に移動できる候補が2つ以上ありますがサフィックスの指定がないため特定できません : #{candidate_soldiers.collect(&:name).join(', ')})"
        end

        if !direct_trigger && candidate_soldiers.count >= 2 && !point_from
          errors_add AmbiguousFormatError, "#{point}に移動できる候補が2つ以上ありますが#{motion_str}からは特定できません : #{candidate_soldiers.collect(&:name).join(', ')})"
        end

        if force_direct_trigger && !player.piece_box.exist?(piece)
          errors_add HoldPieceNotFound, "打を明示しましたが持駒に#{piece}がありません"
        end

        if direct_abbreviation? && !player.piece_box.exist?(piece)
          errors_add HoldPieceNotFound2, "移動できる駒がなく打の省略形と思われる指し手ですが#{piece}を持っていません"
        end

        if !direct_trigger && candidate_soldiers.empty?
          errors_add MovableBattlerNotFound, "#{player.call_name}の手番で#{point}に移動できる駒がありません"
        end

        if direct_trigger && promoted
          errors_add IllegibleFormat, "成・不成と打が干渉しています"
        end
      end

      def origin_soldier
        @origin_soldier ||= -> {
          if !force_direct_trigger
            v = candidate_soldiers_select
            if v.size == 1
              v.first
            end
          end
        }.call
      end

      private

      def candidate_soldiers_select
        @candidate_soldiers_select ||= -> {
          list = candidate_soldiers

          if list.size >= 2
            if v = left_right
              if md = v.match(/[左右]/)
                if piece.brave?
                  m = {"左" => :first, "右" => :last}.fetch(md.to_s)
                  m = flip_if_white(m)
                  list = list.sort_by { |e| e.point.x.value }.send(m, 1)
                else
                  m = {"左" => :>, "右" => :<}.fetch(md.to_s)
                  m = flip_if_white(m)
                  list = list.find_all do |e|
                    point.x.value.send(m, e.point.x.value)
                  end
                end
              end
            end
          end

          if list.size >= 2
            if v = up_down
              if md = v.match(/[上引]/)
                m = {"上" => :<, "引" => :>}.fetch(md.to_s)
                m = flip_if_white(m)
                list = list.find_all do |e|
                  point.y.value.send(m, e.point.y.value)
                end
              end
            end
          end

          # 竜が1つだけで１５の竜が５５に来たときも「１五竜寄」なので左右1マスの限定のチェックは入れてはいけない
          if list.size >= 2
            if v = up_down
              if v.include?("寄")
                list = list.find_all { |e| e.point.y == point.y }
              end
            end
          end

          # 真下にあるもの
          if list.size >= 2
            if one_up?
              y = point.y.value + player.location.which_val(1, -1)
              list = list.find_all { |e|
                e.point.x == point.x && e.point.y.value == y
              }
            end
          end

          list
        }.call
      end

      # 「打」の省略形か？
      # 「同」も「左右や打」も移動候補もないとき「打」の省略系
      def direct_abbreviation?
        !suffix_exist? && candidate_soldiers.empty?
      end

      # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
      # https://ameblo.jp/written-by-m/entry-10365417107.html
      # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
      # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
      # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
      def up_down
        @up_down ||= -> {
          if s = input[:ki2_up_down]
            if piece.brave?
              s = s.tr("行", "上")
            end
            s
          end
        }.call
      end

      def flip_if_white(key)
        if player.location.key == :white
          key = self.class.flip_table[key]
        end
        key
      end
    end
  end
end
