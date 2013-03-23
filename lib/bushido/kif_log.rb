# -*- coding: utf-8 -*-
#
# 棋譜の一手分の保存用
#
module Bushido
  class KifLog < Hash
    attr_reader :point, :piece, :promoted, :promote_trigger, :put_on_trigger, :origin_point, :player, :candidate, :same_point

    def initialize(attrs)
      attrs.each{|k, v|
        instance_variable_set("@#{k}", v)
      }
    end

    # KIF形式の最後の棋譜
    def to_s_simple(options = {})
      options = {
        :with_mark => false,
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
      if @put_on_trigger
        s << "打"
      end
      if @origin_point
        s << "(#{@origin_point.number_format})"
      end
      s.join
    end

    def to_pair
      [to_s_simple, to_s_human]
    end

    def to_s_human(options = {})
      options = {
        :with_mark => false,
      }.merge(options)
      s = []
      if options[:with_mark]
        s << @player.location.mark
      end
      if @same_point
      # if __same_point?
        s << "同"
      else
        s << @point.name
      end
      s << @piece.some_name(@promoted)

      # 候補が2つ以上あったとき
      if @candidate && @candidate.size > 1
        if Piece::Brave === @piece
          # 大駒の場合、
          # 【移動元で二つの龍が水平線上にいる】or【移動先の水平線上よりすべて上かすべて下】
          if @candidate.collect{|s|s.point.y.value}.uniq.size == 1 || [     # 移動元で二つの龍が水平線上にいる
              @candidate.all?{|s|s.point.y.value < @point.y.value},   # 移動先の水平線上よりすべて上または
              @candidate.all?{|s|s.point.y.value > @point.y.value},   #                     すべて下
            ].any?

            sorted_candidate = @candidate.sort_by{|soldier|soldier.point.x.value}
            if sorted_candidate.last.point.x.value == @origin_point.x.value
              s << select_char("右左")
            end
            if sorted_candidate.first.point.x.value == @origin_point.x.value
              s << select_char("左右")
            end
          end
        else
          # 普通駒の場合、
          # 左右がつくのは移動先の左側と右側の両方に駒があるとき
          if [@candidate.any?{|s|s.point.x.value < @point.x.value},      # 移動先の左側に駒がある、かつ
              @candidate.any?{|s|s.point.x.value > @point.x.value}].all? # 移動先の右側に駒がある
            if @point.x.value < @origin_point.x.value
              s << select_char("右左")
            end
            if @point.x.value > @origin_point.x.value
              s << select_char("左右")
            end
          end

          # 目標座標の左方向または右方向に駒があって、自分は縦の列から来た場合
          if [@candidate.any?{|s|s.point.x.value < @point.x.value},
              @candidate.any?{|s|s.point.x.value > @point.x.value}].any?
            if @point.x.value == @origin_point.x.value
              s << "直"
            end
          end
        end

        # 目標地点の上と下、両方にあって区別がつかないとき、
        if [@candidate.any?{|s|s.point.y.value < @point.y.value},
            @candidate.any?{|s|s.point.y.value > @point.y.value}].all? ||
            # 上か下にあって、水平線にもある
            [@candidate.any?{|s|s.point.y.value < @point.y.value},
            @candidate.any?{|s|s.point.y.value > @point.y.value}].any? && @candidate.any?{|s|s.point.y.value == @point.y.value}

          # 下から来たのなら、ひき"上"げる
          if @point.y.value < @origin_point.y.value
            s << select_char("上引")
          end
          # 上から来たなら、"引"く
          if @point.y.value > @origin_point.y.value
            s << select_char("引上")
          end
        end

        # 目標座標の上方向または下方向に駒があって、自分は真横の列から来た場合
        if [@candidate.any?{|s|s.point.y.value < @point.y.value},
            @candidate.any?{|s|s.point.y.value > @point.y.value}].any?
          if @point.y.value == @origin_point.y.value
            s << "寄"
          end
        end
      end
      if @promote_trigger
        s << "成"
      else
        if @origin_point && @point
          if @origin_point.promotable?(@player.location) || @point.promotable?(@player.location)
            unless @promoted
              if @piece.promotable?
                s << "不成"
              end
            end
          end
        end
      end
      if @put_on_trigger
        s << "打"
      end
      s.join
    end

    private

    # 未使用
    # リアルタイムに探すバージョン
    # @player.mediator.kif_logs にすでに自分が記録されているとする
    def __same_point?
      if @player.mediator
        logs = @player.mediator.kif_logs
        logs = logs[0..logs.index(self)] # ← ここがだめっぽい
        # 自分の手と同じところを見て「同」とやっても結局、自分の駒の上に駒を置くことになってエラーになるのでここは相手を探した方がいい
        # ずっと遡っていくとまた嵌りそうな気がするけどやってみる
        if log = logs.reverse.find{|log|log.player.location != @player.location} # player == player で動くか確認
          if log.point == @point
            true
          end
        end
      end
    end

    def select_char(str)
      str.chars.to_a.send(@player.location._which(:first, :last))
    end
  end
end
