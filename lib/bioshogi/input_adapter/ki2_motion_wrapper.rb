# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    concern :Ki2MotionWrapper do
      # 「同」「成・不成」「左右」などの指定があるか？
      def suffix_exist?
        same? || !motion_str.empty? || have_promote_or_not_promote_force_instruction?
      end

      def motion_str
        @motion_str ||= [input[:ki2_one_up], input[:ki2_left_right], input[:ki2_up_down]].join
      end

      # 直
      def one_up?
        input[:ki2_one_up]
      end

      # 左右
      def left_right
        input[:ki2_left_right]
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
    end
  end
end
