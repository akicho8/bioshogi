#
# Player#execute 実体
#
module Bushido
  class Runner
    attr_reader :point, :origin_point, :piece, :source, :player

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
      @md = @source.match(input_regexp)
      unless @md
        raise SyntaxDefact, "表記が間違っています : #{@source.inspect} (#{input_regexp.inspect} にマッチしません)"
      end

      # # @md が MatchData のままだと Marshal.dump できない病で死にます
      # @md = @md.names.inject({}){|h, k|h.merge(k.to_sym => @md[k])} # to_h とかあるはず(？)

      read_point

      @piece, @promoted = Piece.promoted_fetch(@md[:piece]).values_at(:piece, :promoted)

      begin
        # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
        if @md[:motion2].to_s.match?(/不?成/) && !@piece.promotable?
          raise NoPromotablePiece, "#{@md[:motion1].inspect} としましたが「#{@piece.name}」は裏がないので「成」も「不成」も指定できません : #{@source.inspect}"
        end

        @promote_trigger = (@md[:motion2] == "成")
      end

      @strike_trigger = @md[:motion2].to_s.include?("打")
      @origin_point = nil
      @done = false
      @candidate = nil

      # kif → ki2 変換するときのために @candidate は必要
      # 指定の場所に来れる盤上の駒に絞る
      @soldiers = @player.soldiers
      @soldiers = @soldiers.find_all { |e| e.piece.key == @piece.key }                    # 同じ種類に絞る
      @soldiers = @soldiers.find_all { |e| !!e.promoted == !!@promoted }                  # 成っているかどうかで絞る
      @soldiers = @soldiers.find_all { |e| e.movable_infos.any?{|e|e[:point] == @point} } # その場所に凝れる
      @candidate = @soldiers.collect(&:clone)

      if @strike_trigger
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
        end
        soldier_put
      else
        if @md[:origin_point]
          @origin_point = Point.parse(@md[:origin_point])
        end

        unless @origin_point
          # ki2 の場合
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
                soldier_put
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

      @md = nil # MatchData を保持していると Marshal.dump できないため。(これやるまえにraiseで飛んでるんだろうか)

      self
    end

    def hand_log
      HandLog.new({
          point: @point,
          piece: @piece,
          promoted: @promoted,
          promote_trigger: @promote_trigger,
          strike_trigger: @strike_trigger,
          origin_point: @origin_point,
          player: @player,
          candidate: @candidate,
          point_same_p: point_same?, # 前の手と同じかどうかは状況によって変わってしまうためこの時点でさっさと生成しておく
        })
    end

    private

    def read_point
      @point = nil
      if @md[:same] == "同"
        if @player.mediator && hand_log = @player.mediator.hand_logs.last
          @point = hand_log.point
        end
        unless @point
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end
        if @md[:point]
          prefix_pt = Point.parse(@md[:point])
          if Point.parse(@md[:point]) != @point
            raise SamePointDiff, "「同」は#{@point}を意味しますが、前置した座標は「#{prefix_pt}」です (入力:#{@source.inspect})"
          end
        end
      else
        @point = Point.parse(@md[:point])
      end
    end

    # 「７六歩」とした場合「７六歩打」なのか「７六歩(nn)」なのか判断できないので
    # 「７六」に来ることができる歩があれば「７六歩(nn)」と判断する
    # で、「７六」に来ることができる歩 の元の位置を探すのがこのメソッド
    def find_origin_point
      # # 指定の場所に来れる盤上の駒に絞る
      # @soldiers = @player.soldiers.find_all { |soldier| soldier.movable_infos.any?{|e|e[:point] == @point} }
      # @soldiers = @soldiers.find_all{|e|e.piece.key == @piece.key} # 同じ駒に絞る
      # @soldiers = @soldiers.find_all{|e|!!e.promoted == !!@promoted} # 成っているかどうかで絞る
      # @candidate = @soldiers.collect{|s|s.clone}

      if @soldiers.empty?
        # 「打」を省略している場合、持駒から探す
        if @player.piece_fetch(@piece)
          if @promote_trigger
            raise IllegibleFormat, "「2二角打」または「2二角」(打の省略形)とするところを「2二角成打」と書いている系のエラーです : '#{@source.inspect}'"
          end
          @strike_trigger = true
          if @promoted
            raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません: '#{@source.inspect}'"
          end
          soldier = Soldier.new(player: @player, piece: @player.pick_out(@piece), promoted: @promoted)
          @player.put_on_with_valid(@point, soldier)
          @player.soldiers << soldier
          @done = true
        else
          raise MovableSoldierNotFound.new(self)
        end
      end

      unless @done
        if @soldiers.size > 1
          if @md[:motion1]
            assert_valid_format("直上")
            assert_valid_format("左右直")
            assert_valid_format("引上寄")
            find_soldiers
          end
          if @soldiers.size > 1
            raise AmbiguousFormatError, "#{@point.name}に移動できる駒が多すぎます。#{@source.inspect} の表記を明確にしてください。(移動元候補: #{@soldiers.collect(&:mark_with_formal_name).join(', ')})\n#{@player.board_with_pieces}"
          end
        end

        # Point[@player.board.surface.invert[@soldiers.first]] として引くことも可能だけど遅い
        @origin_point = @soldiers.first.point
      end
    end

    def find_soldiers
      __saved_soldiers = @soldiers

      # 上下左右は後手なら反転する
      cond = "左右"
      if @md[:motion1].match?(/[#{cond}]/)
        if @piece.brave?
          m = _method([:first, :last], cond)
          @soldiers = @soldiers.sort_by{|soldier|soldier.point.x.value}.send(m, 1)
        else
          m = _method([:>, :<], cond)
          @soldiers = @soldiers.find_all{|soldier|@point.x.value.send(m, soldier.point.x.value)}
        end
      end
      cond = "上引"
      if @md[:motion1].match?(/[#{cond}]/)
        m = _method([:<, :>], cond)
        @soldiers = @soldiers.find_all{|soldier|@point.y.value.send(m, soldier.point.y.value)}
      end

      # 寄 と 直 は先手後手関係ないので反転する必要なし
      if true
        if @md[:motion1].include?("寄")
          # TODO: 厳密には左右1個分だけチェックする
          @soldiers = @soldiers.find_all { |e| e.point.y == @point.y }
        end

        if @md[:motion1].include?("直")
          # TODO: 厳密には下にあるもののみとする
          @soldiers = @soldiers.find_all { |e| e.point.x == @point.x }
        end
      end

      if @soldiers.empty?
        raise AmbiguousFormatError, "#{@point.name}に移動できる駒がなくなりまりました。#{@source.inspect} の表記を明確にしてください。(移動元候補だったがなくなってしまった駒: #{__saved_soldiers.collect(&:mark_with_formal_name).join(', ')})\n#{@player.board_with_pieces}"
      end
    end

    def _method(method_a_or_b, str_a_or_b)
      str_a_or_b = str_a_or_b.chars.to_a
      if @md[:motion1].match?(/#{str_a_or_b.last}/)
        method_a_or_b = method_a_or_b.reverse
      end
      @player.location.where_value(*method_a_or_b)
    end

    def assert_valid_format(valid_list)
      _chars = valid_list.chars.to_a.find_all{|v|@md[:motion1].include?(v)}
      if _chars.size > 1
        raise SyntaxDefact, "#{_chars.join('と')}は同時に指定できません。【#{@source}】を見直してください。\n#{@player.board_with_pieces}"
      end
    end

    def soldier_put
      soldier = Soldier.new(player: @player, piece: @player.pick_out(@piece), promoted: @promoted)
      @player.put_on_with_valid(@point, soldier)
      @player.soldiers << soldier
      @done = true
    end

    def point_same?
      if @player.mediator && hand_logs = @player.mediator.hand_logs
        # 自分の手と同じところを見て「同」とやっても結局、自分の駒の上に駒を置くことになってエラーになるのでここは相手を探した方がいい
        # ずっと遡っていくとまた嵌りそうな気がするけどやってみる
        if hand_log = hand_logs.reverse.find { |e| e.player.location != @player.location }
          hand_log.point == @point
        end
      end
    end

    def input_regexp
      /\A
        (?<point>#{Point.regexp})?
        (?<same>同)?
        \p{blank}*
        (?<piece>#{Piece.all_names.join("|")})
        (?<motion1>右上|右引|右|左上|左引|左|直|引|寄|上)?
        (?<motion2>不成|成|打)?
        (\((?<origin_point>.*)\))
      ?/ox
    end
  end
end
