# -*- coding: utf-8 -*-
#
# Player#execute 実体
#
module Bushido
  class OrderParser
    attr_reader :point

    def initialize(player)
      @player = player
    end

    def execute(str)
      @source = str
      @regexp = /\A(?<point>同|..)#{WHITE_SPACE}*(?<piece>#{Piece.names.join("|")})(?<suffix>[不成打右左直引寄上]+)?(\((?<source_point>.*)\))?/
      @md = @source.match(@regexp)
      @md or raise SyntaxError, "表記が間違っています : #{@source.inspect} (#{@regexp.inspect} にマッチしません)"

      read_point

      @promoted, @piece = Piece.parse!(@md[:piece]).values_at(:promoted, :piece)

      begin
        # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
        if @md[:suffix].to_s.match(/不?成/) && !@piece.promotable?
          raise NoPromotablePiece, "#{@md[:suffix].inspect} としましたが「#{@piece.name}」は表面しかないので「成」も「不成」も指定しちゃいけません : #{@source.inspect}"
        end

        @promote_trigger = nil
        case @md[:suffix].to_s
        when /不成/
        when /成/
          @promote_trigger = true
        end
      end

      @put_on_trigger = @md[:suffix].to_s.match(/打/)
      @source_point = nil
      @done = false
      @candidate = nil

      if @put_on_trigger
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
        end
        put_soldier
      else
        if @md[:source_point]
          @source_point = Point.parse(@md[:source_point])
        end
        unless @source_point
          find_source_point
        end
        unless @done
          @source_soldier = @player.board_fetch_as_soldier(@source_point)

          unless @promote_trigger
            if @source_soldier.promoted? && !@promoted
              # 成駒を成ってない状態にして移動しようとした場合は、いったん持駒を確認する
              if @player.piece_fetch(@piece)
                @put_on_trigger = true
                @source_point = nil
                put_soldier
              else
                raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{@source.inspect}の駒は#{@source_soldier.piece_current_name}と書いてください\n#{@player.board_with_pieces}"
              end
            end
          end

          unless @done
            @player.move_to(@source_point, @point, @promote_trigger)
          end
        end
      end

      # @prev_player_point = @player.prev_player.moved_point

      @md = nil                 # MatchData を保持していると Marshal.dump できないため。

      self
    end

    # KIF形式の最後の棋譜
    def last_kif
      s = []
      s << @point.name
      s << @piece.some_name(@promoted)
      if @promote_trigger
        s << "成"
      end
      if @put_on_trigger
        s << "打"
      end
      if @source_point
        s << "(#{@source_point.number_format})"
      end
      s.join
    end

    def last_kif_pair
      [last_kif, last_ki2]
    end

    def last_ki2
      s = []
      if @player.point_logs && @player.point_logs[-2] == @point
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
            if sorted_candidate.last.point.x.value == @source_point.x.value
              s << select_char("右左")
            end
            if sorted_candidate.first.point.x.value == @source_point.x.value
              s << select_char("左右")
            end
          end
        else
          # 普通駒の場合、
          # 左右がつくのは移動先の左側と右側の両方に駒があるとき
          if [@candidate.any?{|s|s.point.x.value < @point.x.value},      # 移動先の左側に駒がある、かつ
              @candidate.any?{|s|s.point.x.value > @point.x.value}].all? # 移動先の右側に駒がある
            if @point.x.value < @source_point.x.value
              s << select_char("右左")
            end
            if @point.x.value > @source_point.x.value
              s << select_char("左右")
            end
          end

          # 目標座標の左方向または右方向に駒があって、自分は縦の列から来た場合
          if [@candidate.any?{|s|s.point.x.value < @point.x.value},
              @candidate.any?{|s|s.point.x.value > @point.x.value}].any?
            if @point.x.value == @source_point.x.value
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
          if @point.y.value < @source_point.y.value
            s << select_char("上引")
          end
          # 上から来たなら、"引"く
          if @point.y.value > @source_point.y.value
            s << select_char("引上")
          end
        end

        # 目標座標の上方向または下方向に駒があって、自分は真横の列から来た場合
        if [@candidate.any?{|s|s.point.y.value < @point.y.value},
            @candidate.any?{|s|s.point.y.value > @point.y.value}].any?
          if @point.y.value == @source_point.y.value
            s << "寄"
          end
        end
      end
      if @promote_trigger
        s << "成"
      else
        if @source_point && @point
          if @source_point.promotable?(@player.location) || @point.promotable?(@player.location)
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

    def read_point
      @point = nil
      if @md[:point] == "同"
        if @player.point_logs
          @point = @player.point_logs.last
        end
        unless @point
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end
      else
        @point = Point.parse(@md[:point])
      end
    end

    def find_source_point
      @soldiers = @player.soldiers.find_all{|soldier|soldier.moveable_points.include?(@point)}
      @soldiers = @soldiers.find_all{|e|e.piece.class == @piece.class}
      @soldiers = @soldiers.find_all{|e|e.promoted == @promoted}
      @candidate = @soldiers.collect{|s|s.clone}

      if @soldiers.empty?
        if @player.piece_fetch(@piece)
          if @promote_trigger
            raise IllegibleFormat, "「2二角打」または「2二角」(打の省略形)とするところを「2二角成打」と書いている系のエラーです。: '#{@source.inspect}'"
          end
          @put_on_trigger = true
          if @promoted
            raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : '#{@source.inspect}'"
          end
          soldier = Soldier.new(:player => @player, :piece => @player.pick_out(@piece), :promoted => @promoted)
          @player.put_on_with_valid(@point, soldier)
          @player.soldiers << soldier
          @done = true
        else
          raise MovableSoldierNotFound, "#{@point.name}に移動できる#{@piece.name}がありません。'#{@source}' の入力が間違っているのかもしれません"
        end
      end

      unless @done
        if @soldiers.size > 1
          if @md[:suffix]
            assert_valid_format("左右直")
            assert_valid_format("引上寄")
            find_soldiers
          end
          if @soldiers.size > 1
            raise AmbiguousFormatError, "#{@point.name}に移動できる駒が多すぎます。#{@source.inspect} の表記を明確にしてください。(移動元候補: #{@soldiers.collect(&:formality_name).join(', ')})\n#{@player.board_with_pieces}"
          end
        end

        # @source_point = Point[@player.board.surface.invert[@soldiers.first.to_h]]
        @source_point = @soldiers.first.point
      end
    end

    def find_soldiers
      __saved_soldiers = @soldiers
      cond = "左右"
      if @md[:suffix].match(/[#{cond}]/)
        if Piece::Brave === @piece
          m = _method([:first, :last], cond)
          @soldiers = @soldiers.sort_by{|soldier|soldier.point.x.value}.send(m, 1)
        else
          m = _method([:>, :<], cond)
          @soldiers = @soldiers.find_all{|soldier|@point.x.value.send(m, soldier.point.x.value)}
        end
      end
      cond = "上引"
      if @md[:suffix].match(/[#{cond}]/)
        m = _method([:<, :>], cond)
        @soldiers = @soldiers.find_all{|soldier|@point.y.value.send(m, soldier.point.y.value)}
      end
      cond = "寄直"
      if @md[:suffix].match(/[#{cond}]/)
        m = _method([:y, :x], cond)
        @soldiers = @soldiers.find_all{|soldier|soldier.point.send(m) == @point.send(m)}
      end
      if @soldiers.empty?
        raise AmbiguousFormatError, "#{@point.name}に移動できる駒がなくなった。#{@source.inspect} の表記を明確にしてください。(移動元候補だったけどなくなってしまった駒: #{__saved_soldiers.collect(&:formality_name).join(', ')})\n#{@player.board_with_pieces}"
      end
    end

    def _method(method_a_or_b, str_a_or_b)
      str_a_or_b = str_a_or_b.chars.to_a
      if @md[:suffix].match(/#{str_a_or_b.last}/)
        method_a_or_b = method_a_or_b.reverse
      end
      @player.location._which(*method_a_or_b)
    end

    def assert_valid_format(valid_list)
      _chars = valid_list.chars.to_a.find_all{|v|@md[:suffix].include?(v)}
      if _chars.size > 1
        raise SyntaxError, "#{_chars.join('と')}は同時に指定できません。【#{@source}】を見直してください。\n#{@player.board_with_pieces}"
      end
    end

    # 未使用
    def last_info
      {
        # :prev_player_point => @prev_player_point,
        :promoted          => @promoted,
        :promote_trigger   => @promote_trigger,
        :source_point      => @source_point,
        :moved_point       => @point,
        :piece             => @piece,
        :put_on_trigger    => @put_on_trigger,
        :candidate         => @candidate,
        :last_piece        => @last_piece,
      }
    end

    def select_char(str)
      str.chars.to_a.send(@player.location._which(:first, :last))
    end

    def put_soldier
      soldier = Soldier.new(:player => @player, :piece => @player.pick_out(@piece), :promoted => @promoted)
      @player.put_on_with_valid(@point, soldier)
      @player.soldiers << soldier
      @done = true
    end
  end
end
