#
# 棋譜の一手分の保存用
#
module Bushido
  class HandLog
    attr_reader :point, :piece, :promoted, :promote_trigger, :strike_trigger, :origin_point, :player, :candidate, :point_same_p

    def initialize(attrs)
      attrs.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    # 両方返す
    # 主にテスト用
    def to_kif_ki2
      [to_s_kif, to_s_ki2]
    end

    # "７六歩" のようなCPUに優しいKIF形式の表記で返す
    def to_s_kif(options = {})
      options = {
        with_mark: false,
      }.merge(options)

      s = []
      if options[:with_mark]
        s << @player.location.mark
      end
      s << @point.name
      s << @piece.some_name(@promoted)
      if @promote_trigger
        s << "成"
      end
      if @strike_trigger
        s << "打"
      end
      if @origin_point
        s << "(#{@origin_point.number_format})"
      end
      s.join
    end

    # "58金右" のような人間向けの表記を返す
    def to_s_ki2(options = {})
      Ki2FormatConv.new(self, options).to_s
    end

    def to_h
      [:point, :piece, :promoted, :promote_trigger, :strike_trigger, :origin_point, :player, :candidate, :point_same_p].inject({}) {|a, key| a.merge(key => send(key)) }
    end

    class Ki2FormatConv
      def initialize(hand_log, options = {})
        @hand_log = hand_log
        @options = {
          with_mark: false,
          strike_force: false, # 「打」を省略できるときでも「打」を明示する
        }.merge(options)
      end

      # "同銀" のような人間向けの表記を返す
      def to_s
        s = []
        if @options[:with_mark]
          s << @hand_log.player.location.mark
        end
        if @hand_log.point_same_p
          s << "同"
        else
          s << @hand_log.point.name
        end
        s << @hand_log.piece.some_name(@hand_log.promoted)

        # motion1
        s << motin1_get

        # motion2
        if true
          if @hand_log.promote_trigger
            s << "成"
          else
            if @hand_log.origin_point && @hand_log.point                          # 移動した and
              if @hand_log.origin_point.promotable?(@hand_log.player.location) || # 移動元が相手の相手陣地 or
                  @hand_log.point.promotable?(@hand_log.player.location)          # 移動元が相手の相手陣地
                unless @hand_log.promoted                                         # 成ってない and
                  if @hand_log.piece.promotable?                                  # 成駒になれる
                    s << "不成"
                  end
                end
              end
            end
          end

          # 日本将棋連盟 棋譜の表記方法
          # https://www.shogi.or.jp/faq/kihuhyouki.html
          #
          # > 到達地点に盤上の駒が移動することも、持駒を打つこともできる場合
          # > 盤上の駒が動いた場合は通常の表記と同じ
          # > 持駒を打った場合は「打」と記入
          # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
          if @hand_log.strike_trigger
            if @options[:strike_force] || @hand_log.candidate.present?
              s << "打"
            end
          end
        end

        s.join
      end

      private

      # 左右引寄直
      def motin1_get
        direct = false
        s = []

        # 候補が2つ以上あったとき
        if @hand_log.candidate && @hand_log.candidate.size > 1
          if @hand_log.piece.brave?
            # 大駒の場合、
            # 【移動元で二つの龍が水平線上にいる】or【移動先の水平線上よりすべて上かすべて下】
            if @hand_log.candidate.collect{|s|s.point.y.value}.uniq.size == 1 || [     # 移動元で二つの龍が水平線上にいる
                @hand_log.candidate.all?{|s|s.point.y.value < ty},   # 移動先の水平線上よりすべて上または
                @hand_log.candidate.all?{|s|s.point.y.value > ty},   #                     すべて下
              ].any?

              sorted_candidate = @hand_log.candidate.sort_by{|soldier|soldier.point.x.value}
              if sorted_candidate.last.point.x.value == ox
                s << which_char("右", "左")
              end
              if sorted_candidate.first.point.x.value == ox
                s << which_char("左", "右")
              end
            end
          else
            # 普通駒の場合、
            # 左右がつくのは移動先の左側と右側の両方に駒があるとき
            # それだけではなく次の場合の「右側の銀が○に移動するとき」も「右」が付く
            # |----+----|
            # | ○ |    |
            # |----+----|
            # | 銀 | 銀 |
            # |----+----|
            # 以前は、移動先の左側に駒がある、かつ移動先の右側に駒があるとしていたが、
            # 左の銀と右の銀の間に行き先が含まれるか？ で判定する方法に変更
            if x_range.cover?(tx)
              if tx < ox
                s << which_char("右", "左")
              elsif tx > ox
                s << which_char("左", "右")
              end
            end

            # 目標座標の左方向または右方向に駒があって、自分は縦の列から来た場合
            if x_range.min < tx || tx < x_range.max
              if tx == ox
                s << "直"
                direct = true   # 「直上」とならないようにするため
              end
            end
          end

          unless direct
            # 目標地点の上と下、両方にあって区別がつかないとき、
            if y_range.min < ty && ty < y_range.max ||
                # 上か下にあって、水平線にもある
                (y_range.min < ty || ty < y_range.max) && @hand_log.candidate.any?{|s|s.point.y.value == ty}

              # 下から来たのなら、ひき"上"げ、
              # 上から来たなら、"引"く
              if ty < oy
                s << which_char("上", "引")
              elsif ty > oy
                s << which_char("引", "上")
              end
            end

            # 目標座標の上方向または下方向に駒があって、自分は真横の列から来た場合
            if y_range.min < ty || ty < y_range.max
              if ty == oy
                s << "寄"
              end
            end
          end
        end
        s
      end

      def which_char(*args)
        @hand_log.player.location.where_value(*args)
      end

      # 移動先
      def tx
        @tx ||= @hand_log.point.x.value
      end

      def ty
        @ty ||= @hand_log.point.y.value
      end

      # 移動元
      def ox
        @ox ||= @hand_log.origin_point.x.value
      end

      def oy
        @oy ||= @hand_log.origin_point.y.value
      end

      # 候補手の座標範囲
      def x_range
        @x_range ||= Range.new(*@hand_log.candidate.collect { |e| e.point.x.value }.minmax)
      end

      def y_range
        @y_range ||= Range.new(*@hand_log.candidate.collect { |e| e.point.y.value }.minmax)
      end
    end
  end
end
