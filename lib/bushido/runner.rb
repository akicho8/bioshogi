#
# Player#execute 実体
#
module Bushido
  class Runner
    class << self
      def input_regexp
        Regexp.union(input_regexp1, input_regexp2)
        # input_regexp1
      end

      def input_regexp1
        /
          (?<point>#{Point.regexp})?
          (?<same>同)?
          \p{blank}*
          (?<piece>#{Piece.all_names.join("|")})
          (?<motion1>[左右][上引]?|[直引寄上])?
          (?<motion2>不?成|打)?
          (\((?<origin_point>\d{2})\))?
        /ox
      end

      def input_regexp2
        csa_names1 = Piece.collect{|e|e.csa_name1}.compact.join("|")
        csa_names2 = Piece.collect{|e|e.csa_name2}.compact.join("|")

        /
          (?<csa_from>[0-9]{2}) # 00 = 駒台
          (?<csa_to>[1-9]{2})
          ((?<csa_basic_piece>#{csa_names1})|(?<csa_promoted_piece>#{csa_names2}))
        /ox
      end
    end

    attr_reader :point, :origin_point, :piece, :source, :player

    def initialize(player)
      @player = player
    end

    def execute(str)
      @point = nil
      @piece = nil
      @origin_point = nil
      @strike_trigger = nil
      @promote_trigger = nil
      @candidate = nil
      @done = false
      @candidate = nil

      @source = str

      @md = @source.match(self.class.input_regexp)
      unless @md
        raise SyntaxDefact, "表記が間違っています : #{@source.inspect} (#{self.class.input_regexp.inspect} にマッチしません)"
      end
      @md = @md.named_captures.symbolize_keys

      if @md[:csa_basic_piece] || @md[:csa_promoted_piece]
        # p @source
        # p self.class.input_regexp2
        # p @source.match(self.class.input_regexp2)
        if @md[:csa_from] == "00"
          @md[:csa_from] = nil
          @md[:motion2] = "打"
        end

        if @md[:csa_from]
          @md[:origin_point] = @md[:csa_from]
        end

        @md[:point] = @md[:csa_to]

        if @md[:csa_basic_piece]
          # 普通の駒
          v = Piece.find{|e|e.csa_name1 == @md[:csa_basic_piece]}
          @md[:piece] = v.name
        end

        if @md[:csa_promoted_piece]
          # このタイミングで成るのかすでに成っていたのかCSA形式だとわからない
          # だから移動元の駒の情報で判断するしかない
          _piece = Piece.find{|e|e.csa_name2 == @md[:csa_promoted_piece]}

          v = @player.board[@md[:origin_point]] or raise MustNotHappen
          if v.promoted?
            @md[:piece] = v.piece.promoted_name
          else
            @md[:piece] = v.piece.name
            @md[:motion2] = "成"
          end
        end
      end

      # # @md が MatchData のままだと Marshal.dump できない病で死にます
      # @md = @md.names.inject({}){|h, k|h.merge(k.to_sym => @md[k])} # to_h とかあるはず(？)

      read_point

      begin
        @piece, @promoted = Piece.promoted_fetch(@md[:piece]).values_at(:piece, :promoted)
      rescue => error
        p @md
        p @md[:piece]
        p error
        p @source
        raise
      end

      begin
        # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
        if @md[:motion2].to_s.match?(/不?成/) && !@piece.promotable?
          raise NoPromotablePiece, "#{@md[:motion1].inspect} としましたが「#{@piece.name}」は裏がないので「成」も「不成」も指定できません : #{@source.inspect}"
        end

        @promote_trigger = (@md[:motion2] == "成")
      end

      @strike_trigger = @md[:motion2].to_s.include?("打")

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
              if @player.piece_lookup(@piece)
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
      case
      when @md[:same] == "同"
        if @player.mediator && hand_log = @player.mediator.hand_logs.last
          @point = hand_log.point
        end
        unless @point
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end

        # 記事などで改ページしたとき、明示的に "同２四歩" と書く場合もあるとのこと
        if @md[:point]
          prefix_pt = Point.parse(@md[:point])
          if Point.parse(@md[:point]) != @point
            raise SamePointDiff, "同は#{@point}を意味しますが明示的に指定した移動先は #{prefix_pt} です : #{@source.inspect}"
          end
        end
      when @md[:point]
        @point = Point.parse(@md[:point])
      else
        raise PointSyntaxError, "移動先の座標が不明です : #{@source.inspect}"
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
        if @player.piece_lookup(@piece)
          if @promote_trigger
            raise IllegibleFormat, "「２二角打」または「２二角」(打の省略形)とするところを「２二角成打」と書いている系のエラーです : '#{@source.inspect}'"
          end
          @strike_trigger = true
          if @promoted
            raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません: '#{@source.inspect}'"
          end
          soldier = Soldier.new(player: @player, piece: @player.piece_pick_out(@piece), promoted: @promoted)
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
      soldier = Soldier.new(player: @player, piece: @player.piece_pick_out(@piece), promoted: @promoted)
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
  end
end
