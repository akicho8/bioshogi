# frozen-string-literal: true

module Warabi
  module InputAdapter
    class Ki2Adapter < KifAdapter
      def self.inversus_table
        @inversus_table ||= -> {
          table = {:first => :last, :> => :<}
          table.merge(table.invert)
        }.call
      end

      # 移動元候補がない場合は打が省略されている
      def direct_trigger
        super || candidate_soldiers.empty?
      end

      def point_from
        @point_from ||= -> {
          if soldier = origin_soldier
            soldier.point
          end
        }.call
      end

      def perform_validations
        super

        if ki2_motion_part
          assert_valid_format("直上")
          assert_valid_format("左右直")
          assert_valid_format("寄引上")
        end

        if candidate_soldiers.size >= 2 && !ki2_motion_part
          raise AmbiguousFormatError, "#{point}に移動できる候補が2つ以上ありますがサフィックスの指定がないため特定できません : #{candidate_soldiers.collect(&:name).join(', ')})"
        end

        if !direct_trigger && candidate_soldiers.count >= 2 && !point_from
          raise AmbiguousFormatError, "#{point}に移動できる候補が2つ以上ありますが#{ki2_motion_part}からは特定できません : #{candidate_soldiers.collect(&:name).join(', ')})"
        end

        if candidate_soldiers.empty? && !player.piece_box.exist?(piece)
          raise MovableBattlerNotFound, "#{player.call_name}の手番で#{point}に移動できる駒がありません。打を省略したと考えても持駒に見つかりません"
        end

        # 飛を持っている状態で▲５５飛成
        if direct_trigger && promoted
          raise IllegibleFormat, "成・不成と打が干渉しています"
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
            if md = motion.match(/[左右]/)
              if piece.brave?
                m = {"左" => :first, "右" => :last}.fetch(md.to_s)
                m = reverse_if_white(m)
                list = list.sort_by { |e| e.point.x.value }.send(m, 1)
              else
                m = {"左" => :>, "右" => :<}.fetch(md.to_s)
                m = reverse_if_white(m)
                list = list.find_all do |e|
                  point.x.value.send(m, e.point.x.value)
                end
              end
            end
          end

          if list.size >= 2
            if md = motion.match(/[上引]/)
              m = {"上" => :<, "引" => :>}.fetch(md.to_s)
              m = reverse_if_white(m)
              list = list.find_all do |e|
                point.y.value.send(m, e.point.y.value)
              end
            end
          end

          # 竜が1つだけで１５の竜が５５に来たときも「１五竜寄」なので左右1マスの限定のチェックは入れてはいけない
          if list.size >= 2
            if motion.include?("寄")
              list = list.find_all { |e| e.point.y == point.y }
            end
          end

          # 真下にあるもの
          if list.size >= 2
            if motion.include?("直")
              y = point.y.value + player.location.which_val(1, -1)
              list = list.find_all { |e|
                e.point.x == point.x && e.point.y.value == y
              }
            end
          end

          list
        }.call
      end

      # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
      # https://ameblo.jp/written-by-m/entry-10365417107.html
      # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
      # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
      # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
      def ki2_motion_part
        @ki2_motion_part ||= -> {
          if s = input[:ki2_motion_part]
            if piece.brave?
              s = s.tr("行", "上")
            end
            s
          end
        }.call
      end

      def motion
        @motion ||= ki2_motion_part.to_s
      end

      def reverse_if_white(key)
        if player.location.key == :black
          key
        else
          self.class.inversus_table[key]
        end
      end

      def assert_valid_format(str)
        chars = str.chars.find_all { |v| ki2_motion_part.include?(v) }
        if chars.size >= 2
          raise SyntaxDefact, "同時に指定できません : #{chars}"
        end
      end
    end
  end
end
