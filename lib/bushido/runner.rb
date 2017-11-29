# frozen-string-literal: true
#
# Player#execute 実体
#
module Bushido
  class Runner
    class << self
      def input_regexp
        @input_regexp ||= Regexp.union(human_input_regexp, csa_input_regexp)
      end

      def human_input_regexp
        point = /(?<point>#{Point.regexp})/o
        same = /(?<same>同)\p{blank}*/

        /
          (#{point}#{same}|#{same}#{point}|#{point}|#{same}) # 12同 or 同12 or 12 or 同 に対応
          (?<piece>#{Piece.all_names.join("|")})
          (?<motion1>[左右直]?[寄引上行]?)
          (?<motion2>不?成|打|合|生)?
          (?<origin_point>\(\d{2}\))? # scan の結果を join したものがマッチした元の文字列と一致するように "()" も含めて取る
        /ox
      end

      def csa_input_regexp
        csa_basic_names = Piece.collect(&:csa_basic_name).compact.join("|")
        csa_promoted_names = Piece.collect(&:csa_promoted_name).compact.join("|")

        /
          (?<csa_from>[0-9]{2}) # 00 = 駒台
          (?<csa_to>[1-9]{2})
          ((?<csa_basic_name>#{csa_basic_names})|(?<csa_promoted_name>#{csa_promoted_names}))
        /ox
      end
    end

    attr_reader :point, :origin_point, :piece, :source, :player

    def initialize(player)
      @player = player
    end

    def execute(str)
      @source = str

      # hand_log を作るための変数たち
      @point           = nil
      @piece           = nil
      @promoted        = nil
      @promote_trigger = nil
      @strike_trigger  = nil
      @origin_point    = nil
      @candidate       = nil

      @mini_soldier = nil
      @done = false

      @md = @source.match(self.class.input_regexp)
      unless @md
        raise SyntaxDefact, "表記が間違っています : #{@source.inspect} (#{self.class.input_regexp.inspect} にマッチしません)"
      end
      @md = @md.named_captures.symbolize_keys

      if @md[:csa_basic_name] || @md[:csa_promoted_name]
        # p @source
        # p self.class.csa_input_regexp
        # p @source.match(self.class.csa_input_regexp)
        if @md[:csa_from] == "00"
          @md[:csa_from] = nil
          @md[:motion2] = "打"
        end

        if @md[:csa_from]
          @md[:origin_point] = @md[:csa_from]
        end

        @md[:point] = @md[:csa_to]

        if @md[:csa_basic_name]
          # 普通の駒
          v = Piece.find{|e|e.csa_basic_name == @md[:csa_basic_name]}
          @md[:piece] = v.name
        end

        if @md[:csa_promoted_name]
          # このタイミングで成るのかすでに成っていたのかCSA形式だとわからない
          # だから移動元の駒の情報で判断するしかない
          _piece = Piece.find{|e|e.csa_promoted_name == @md[:csa_promoted_name]}

          v = @player.board[@md[:origin_point]] or raise MustNotHappen
          if v.promoted?
            @md[:piece] = v.piece.promoted_name
          else
            @md[:piece] = v.piece.name
            @md[:motion2] = "成"
          end
        end
      end

      if @md[:origin_point]
        @md[:origin_point] = @md[:origin_point].slice(/\d+/)
      end

      begin
        @mini_soldier = Piece.promoted_fetch(@md[:piece])
        @piece, @promoted = @mini_soldier.values_at(:piece, :promoted)
      rescue => error
        raise MustNotHappen, {error: error, md: @md, source: @source}.inspect
      end

      # # @md が MatchData のままだと Marshal.dump できない病で死にます
      # @md = @md.names.inject({}){|h, k|h.merge(k.to_sym => @md[k])} # to_h とかあるはず(？)

      read_point

      if true
        # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
        # https://ameblo.jp/written-by-m/entry-10365417107.html
        # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
        # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
        # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
        if @piece.brave?
          if @md[:motion1]
            @md[:motion1] = @md[:motion1].gsub(/行/, "上")
          end
        end
      end

      begin
        # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
        if @md[:motion2].to_s.match?(/不?成|生/) && !@piece.promotable?
          raise NoPromotablePiece, "#{@md[:motion1].inspect} としましたが #{@piece.name.inspect} は裏がないので「成・不成・生」は指定できません : #{@source.inspect}"
        end

        @promote_trigger = (@md[:motion2] == "成")
      end

      @strike_trigger = @md[:motion2].to_s.match?(/[打合]/)

      # 指定の場所に来れる盤上の駒に絞る
      # kif → ki2 変換するときのために @candidate を常に作っとかんといけない
      @soldiers = @player.soldiers.find_all { |e|
        !!e.promoted == !!@promoted &&                      # 成っているかどうかで絞る
        e.piece.key == @piece.key &&                        # 同じ種類に絞る
        e.movable_infos.any? { |e| e[:point] == @point } && # 目的地に来れる
        true
      }
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
          find_origin_point     # KI2の場合
        end

        unless @done
          @source_soldier = @player.board.lookup(@origin_point)

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
          soldier = Soldier.new(player: @player, piece: @player.piece_pick_out(@piece), point: @point, promoted: @promoted)
          @player.put_on_with_valid(soldier)
          @player.soldiers << soldier
          @done = true
        else
          raise MovableSoldierNotFound, "#{@player.location.name}の手番で #{@point.name.inspect} の地点に移動できる #{@mini_soldier.piece_name.inspect} がありません。入力した #{@source.inspect} がまちがっている可能性があります\n#{@player.mediator}"
        end
      end

      unless @done
        if @soldiers.size > 1
          if @md[:motion1]
            # TODO: 入力の正規表現を改めたのでこのチェックは不要かもしれない
            assert_valid_format("直上")
            assert_valid_format("左右直")
            assert_valid_format("寄引上")
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

        # 真下にあるもの
        if @md[:motion1].include?("直")
          @soldiers = @soldiers.find_all { |e|
            e.point.x == @point.x &&
            e.point.y.value == @point.y.value + @player.location.which_val(1, -1)
          }
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
      @player.location.which_val(*method_a_or_b)
    end

    def assert_valid_format(valid_list)
      _chars = valid_list.chars.to_a.find_all{|v|@md[:motion1].include?(v)}
      if _chars.size > 1
        raise SyntaxDefact, "#{_chars.join('と')}は同時に指定できません。【#{@source}】を見直してください。\n#{@player.board_with_pieces}"
      end
    end

    def soldier_put
      soldier = Soldier.new(player: @player, piece: @player.piece_pick_out(@piece), promoted: @promoted, point: @point)
      @player.put_on_with_valid(soldier)
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
