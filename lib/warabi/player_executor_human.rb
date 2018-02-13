# frozen-string-literal: true

module Warabi
  concern :PlayerExecutorHuman do
    private

    def direct_guess
      if @soldiers.empty?
        # 「打」を省略している場合、持駒から探す
        unless @player.piece_box.exist?(@piece)
          raise MovableBattlerNotFound, "#{@player.location.name}の手番で #{@point.name.inspect} の地点に移動できる #{@piece.any_name(@promoted)} がありません。入力した #{@source.inspect} がまちがっている可能性があります\n#{@player.mediator}"
        end

        if @promote_trigger
          raise IllegibleFormat, "「２二角打」または「２二角」(打の省略形)とするところを「２二角成打」と書いている系のエラーです : '#{@source.inspect}'"
        end

        @direct_trigger = true
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません: '#{@source.inspect}'"
        end

        soldier_put_on_process
      end
    end

    # 「７六歩」とした場合「７六歩打」なのか「７六歩(nn)」なのか判断できないので
    # 「７六」に来ることができる歩があれば「７六歩(nn)」と判断する
    # で、「７六」に来ることができる歩 の元の位置を探すのがこのメソッド
    def point_from_guess
      unless @done
        if @soldiers.size > 1
          if @input2.motion_part
            if ENV["WARABI_ENV"] == "test"
              assert_valid_format("直上")
              assert_valid_format("左右直")
              assert_valid_format("寄引上")
            end
            find_soldiers
          end
          if @soldiers.size > 1
            raise AmbiguousFormatError, "#{@point.name}に移動できる駒が複数あります。#{@source.inspect} の表記を明確にしてください。(移動元候補: #{@soldiers.collect(&:name).join(' ')})\n#{@player.mediator.to_bod}"
          end
        end

        # Point[@player.board.surface.invert[@soldiers.first]] として引くことも可能だけど遅い
        @point_from = @soldiers.first.point
      end
    end

    def find_soldiers
      __saved_soldiers = @soldiers

      # 上下左右は後手なら反転する
      cond = "左右"
      if @input2.motion_part.match?(/[#{cond}]/)
        if @piece.brave?
          m = _method([:first, :last], cond)
          @soldiers = @soldiers.sort_by { |soldier| soldier.point.x.value }.send(m, 1)
        else
          m = _method([:>, :<], cond)
          @soldiers = @soldiers.find_all{|soldier|@point.x.value.send(m, soldier.point.x.value)}
        end
      end
      cond = "上引"
      if @input2.motion_part.match?(/[#{cond}]/)
        m = _method([:<, :>], cond)
        @soldiers = @soldiers.find_all{|soldier|@point.y.value.send(m, soldier.point.y.value)}
      end

      # 寄 と 直 は先手後手関係ないので反転する必要なし
      if true
        if @input2.motion_part.include?("寄")
          # TODO: 厳密には左右1個分だけチェックする
          @soldiers = @soldiers.find_all { |e| e.point.y == @point.y }
        end

        # 真下にあるもの
        if @input2.motion_part.include?("直")
          @soldiers = @soldiers.find_all { |e|
            e.point.x == @point.x &&
            e.point.y.value == @point.y.value + @player.location.which_val(1, -1)
          }
        end
      end

      if @soldiers.empty?
        raise AmbiguousFormatError, "#{@point.name}に移動できる駒がなくなりまりました。#{@source.inspect} の表記を明確にしてください。(移動元候補だったがなくなってしまった駒: #{__saved_soldiers.collect(&:name).join(', ')})\n#{@player.mediator.to_bod}"
      end
    end

    def _method(method_a_or_b, str_a_or_b)
      str_a_or_b = str_a_or_b.chars.to_a
      if @input2.motion_part.match?(/#{str_a_or_b.last}/)
        method_a_or_b = method_a_or_b.reverse
      end
      @player.location.which_val(*method_a_or_b)
    end

    def assert_valid_format(valid_list)
      _chars = valid_list.chars.to_a.find_all { |v| @input2.motion_part.include?(v) }
      if _chars.size > 1
        raise SyntaxDefact, "#{_chars.join('と')}は同時に指定できません。【#{@source}】を見直してください。\n#{@player.mediator.to_bod}"
      end
    end
  end
end
