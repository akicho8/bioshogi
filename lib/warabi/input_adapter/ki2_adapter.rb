# frozen-string-literal: true

module Warabi
  module InputAdapter
    class Ki2Adapter < KifAdapter
      # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
      # https://ameblo.jp/written-by-m/entry-10365417107.html
      # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
      # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
      # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
      def ki2_motion_part
        if s = input[:ki2_motion_part]
          if piece.brave?
            s = s.tr("行", "上")
          end
          s
        end
      end
    end
  end
end
