# -*- coding: utf-8 -*-
#
# Player#execute 実体
#
module Bushido
  class Runner
    attr_reader :point, :origin_point

    def initialize(player)
      @player = player

      @point = nil
      @piece = nil
      @promoted = nil
      @promote_trigger = nil
      @origin_point = nil
      @candidate = nil
    end

    def execute(str)
      @source = str
      @regexp = /\A(?<point>同|..)#{WHITE_SPACE}*(?<piece>#{Piece.names.join("|")})(?<suffix>[不成打右左直引寄上]+)?(\((?<origin_point>.*)\))?/
      @md = @source.match(@regexp)
      @md or raise SyntaxError, "表記が間違っています : #{@source.inspect} (#{@regexp.inspect} にマッチしません)"

      # # @md が MatchData のままだと Marshal.dump できない病で死にます
      # @md = @md.names.inject({}){|h, k|h.merge(k.to_sym => @md[k])} # to_h とかあるはず(？)

      read_point

      @promoted, @piece = Piece.promoted_fetch(@md[:piece]).values_at(:promoted, :piece)

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

      @strike_trigger = @md[:suffix].to_s.include?("打")
      @origin_point = nil
      @done = false
      @candidate = nil

      if @strike_trigger
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
        end
        put_soldier
      else
        if @md[:origin_point]
          @origin_point = Point.parse(@md[:origin_point])
        end
        unless @origin_point
          find_origin_point
        end
        unless @done
          @source_soldier = @player.board.fetch(@origin_point)

          unless @promote_trigger
            if @source_soldier.promoted? && !@promoted
              # 成駒を成ってない状態にして移動しようとした場合は、いったん持駒を確認する
              if @player.piece_fetch(@piece)
                @strike_trigger = true
                @origin_point = nil
                put_soldier
              else
                raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{@source.inspect}の駒は#{@source_soldier.piece_current_name}と書いてください\n#{@player.board_with_pieces}"
              end
            end
          end

          unless @done
            @player.move_to(@origin_point, @point, @promote_trigger)
          end
        end
      end

      @md = nil                 # MatchData を保持していると Marshal.dump できないため。(これやるまえにraiseで飛んでるんだろうか)

      self
    end

    def kif_log
      KifLog.new({
          :point           => @point,
          :piece           => @piece,
          :promoted        => @promoted,
          :promote_trigger => @promote_trigger,
          :strike_trigger  => @strike_trigger,
          :origin_point    => @origin_point,
          :player          => @player,
          :candidate       => @candidate,
          :point_same_p    => point_same?, # 前の手と同じかどうかは状況によって変わってしまうためこの時点でさっさと生成しておく
        })
    end

    # # 互換性用
    # def to_s_simple
    #   kif_log.to_s_simple
    # end
    # 
    # def to_s_human
    #   kif_log.to_s_human
    # end

    # def last_shash
    #   {:point => @point, :piece => @piece, :promoted => @promoted}
    # end

    # def last_info
    #   {
    #     # :prev_player_point => @prev_player_point,
    #     :promoted          => @promoted,
    #     :promote_trigger   => @promote_trigger,
    #     :origin_point      => @origin_point,
    #     :piece             => @piece,
    #     :strike_trigger    => @strike_trigger,
    #     :candidate         => @candidate,
    #     :last_piece        => @last_piece,
    #   }
    # end

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

    def find_origin_point
      @soldiers = @player.soldiers.find_all{|soldier|soldier.moveable_points.include?(@point)} # この場所にあるもの
      @soldiers = @soldiers.find_all{|e|e.piece.class == @piece.class}                         # 同じ駒
      @soldiers = @soldiers.find_all{|e|e.promoted == @promoted}                               # 成っているかどうか
      @candidate = @soldiers.collect{|s|s.clone}

      if @soldiers.empty?
        # 「打」を省略している場合、持駒から探す
        if @player.piece_fetch(@piece)
          if @promote_trigger
            raise IllegibleFormat, "「2二角打」または「2二角」(打の省略形)とするところを「2二角成打」と書いている系のエラーです。: '#{@source.inspect}'"
          end
          @strike_trigger = true
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

        # Point[@player.board.surface.invert[@soldiers.first]] として引くことも可能だけど遅い
        @origin_point = @soldiers.first.point
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

    def put_soldier
      soldier = Soldier.new(:player => @player, :piece => @player.pick_out(@piece), :promoted => @promoted)
      @player.put_on_with_valid(@point, soldier)
      @player.soldiers << soldier
      @done = true
    end

    def point_same?
      if @player.mediator && kif_logs = @player.mediator.kif_logs
        # 自分の手と同じところを見て「同」とやっても結局、自分の駒の上に駒を置くことになってエラーになるのでここは相手を探した方がいい
        # ずっと遡っていくとまた嵌りそうな気がするけどやってみる
        if kif_log = kif_logs.reverse.find{|e|e.player.location != @player.location}
          kif_log.point == @point
        end
      end
    end
  end
end
