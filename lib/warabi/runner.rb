# frozen-string-literal: true
#
# Player#execute 実体
#
module Warabi
  class Runner
    class << self
      def input_regexp
        @input_regexp ||= Regexp.union(human_input_regexp, csa_input_regexp, usi_input_regexp)
      end

      def human_input_regexp
        sankaku = /(?<sankaku>[#{Location.triangles_str}])/o
        point_to = /(?<point_to>#{Point.regexp})/o
        same = /(?<same>同)\p{blank}*/

        /
          #{sankaku}?
          (#{point_to}#{same}|#{same}#{point_to}|#{point_to}|#{same}) # 12同 or 同12 or 12 or 同 に対応
          (?<piece>#{Piece.all_names.join("|")})
          (?<motion1>[左右直]?[寄引上行]?)
          (?<motion2>不?成|打|合|生)?
          (?<point_from>\(\d{2}\))? # scan の結果を join したものがマッチした元の文字列と一致するように "()" も含めて取る
        /ox
      end

      def csa_input_regexp
        csa_basic_names = Piece.collect(&:csa_basic_name).compact.join("|")
        csa_promoted_names = Piece.collect(&:csa_promoted_name).compact.join("|")

        /
          (?<plus_or_minus>[+-])?
          (?<csa_from>[0-9]{2}) # 00 = 駒台
          (?<csa_to>[1-9]{2})
          ((?<csa_basic_name>#{csa_basic_names})|(?<csa_promoted_name>#{csa_promoted_names}))
        /ox
      end

      def usi_input_regexp
        chars = Piece.collect(&:sfen_char).compact.join
        point = /[1-9][[:lower:]]/

        part1 = /(?<usi_piece>[#{chars}])\*(?<usi_to>#{point})/o
        part2 = /(?<usi_from>#{point})(?<usi_to>#{point})(?<usi_nari>\+)?/o

        /((#{part1})|(#{part2}))/o
      end
    end

    attr_reader :point_to, :point_from, :piece, :source, :player, :killed_piece
    attr_reader :skill_set

    def initialize(player)
      @player = player
    end

    def execute(str)
      @source = str

      # hand_log を作るための変数たち
      @point_to           = nil
      @piece           = nil
      @promoted        = nil
      @promote_trigger = nil
      @strike_trigger  = nil
      @point_from    = nil
      @candidate       = nil
      @killed_piece = nil

      @skill_set = SkillSet.new

      @soldier = nil
      @done = false

      @md = @source.match(self.class.input_regexp)
      unless @md
        raise SyntaxDefact, "表記が間違っています : #{@source.inspect} (#{self.class.input_regexp.inspect} にマッチしません)"
      end
      @md = @md.named_captures.symbolize_keys

      if @md[:csa_basic_name] || @md[:csa_promoted_name]
        if @md[:csa_from] == "00"
          @md[:csa_from] = nil
          @md[:motion2] = "打"
        end

        if @md[:csa_from]
          @md[:point_from] = @md[:csa_from]
        end

        @md[:point_to] = @md[:csa_to]

        if @md[:csa_basic_name]
          # 普通の駒
          @md[:piece] = Piece.basic_group.fetch(@md[:csa_basic_name]).name
        end

        if @md[:csa_promoted_name]
          # このタイミングで成るのかすでに成っていたのかCSA形式だとわからない
          # だから移動元の駒の情報で判断するしかない
          _piece = Piece.promoted_group.fetch(@md[:csa_promoted_name])

          v = @player.board[@md[:point_from]] or raise MustNotHappen
          if v.promoted
            @md[:piece] = v.piece.promoted_name
          else
            @md[:piece] = v.piece.name
            @md[:motion2] = "成"
          end
        end
      end

      if @md[:usi_to]
        henkan = -> s { s.gsub(/[[:lower:]]/) { |s| s.ord - 'a'.ord + 1 } }

        if @md[:usi_piece]
          _piece = Piece.find { |e| e.sfen_char == @md[:usi_piece] } or raise
          @md[:piece] = _piece.name
          @md[:motion2] = "打"
          @md[:point_to] = henkan.call(@md[:usi_to])
        else
          @md[:point_from] = henkan.call(@md[:usi_from])
          @md[:point_to] = henkan.call(@md[:usi_to])
          if @md[:usi_nari] == "+"
            @md[:motion2] = "成"
          end
          v = @player.board[@md[:point_from]] or raise MustNotHappen
          @md[:piece] = v.piece_current_name
        end
      end

      if @md[:point_from]
        @md[:point_from] = @md[:point_from].slice(/\d+/)
      end

      begin
        @soldier = Soldier.new_with_promoted(@md[:piece])
        @piece = @soldier.piece
        @promoted = @soldier.promoted
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

      @battlers = @player.battlers.find_all { |e|
        !!e.promoted == !!@promoted &&                      # 成っているかどうかで絞る
        e.piece.key == @piece.key &&                        # 同じ種類に絞る
        e.movable_infos.any? { |e| e.point == @point_to } && # 目的地に来れる
        true
      }
      @candidate = @battlers.collect(&:clone)

      if @strike_trigger
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
        end
        battler_put
      else
        if @md[:point_from]
          @point_from = Point.fetch(@md[:point_from])
        end

        unless @point_from
          find_origin_point     # KI2の場合
        end

        unless @done
          if true
            source_battler = @player.board.lookup(@point_from)
            if !@promote_trigger
              if source_battler && source_battler.promoted && !@promoted
                # 成駒を成ってない状態にして移動しようとした場合は、いったん持駒を確認する
                if @player.piece_box.exist?(@piece)
                  @strike_trigger = true
                  @point_from = nil
                  battler_put
                else
                  raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{@source.inspect}の駒は#{source_battler.piece_current_name}と書いてください\n#{@player.board_with_pieces}"
                end
              end
            end
          end

          unless @done
            if battler = @player.board.lookup(@point_to)
              @killed_piece = battler.piece
            end
            @player.move_to(@point_from, @point_to, @promote_trigger)
          end
        end
      end

      @md = nil # MatchData を保持していると Marshal.dump できないため。(これやるまえにraiseで飛んでるんだろうか)

      self
    end

    def hand_log
      HandLog.new({
          current_soldier: current_soldier,
          before_soldier: before_soldier,
          killed_piece: @killed_piece,

          point_to: @point_to,
          piece: @piece,
          promoted: @promoted,
          promote_trigger: @promote_trigger,
          strike_trigger: @strike_trigger,
          point_from: @point_from,
          player: @player,
          candidate: @candidate,
          point_same_p: point_same?, # 前の手と同じかどうかは状況によって変わってしまうためこの時点でさっさと生成しておく

          skill_set: @skill_set,
        })
    end

    def current_soldier
      @current_soldier ||= Soldier.create(piece: @piece, promoted: (@promoted || @promote_trigger), point: @point_to, location: @player.location)
    end

    def before_soldier
      if @point_from
        @before_soldier ||= Soldier.create(piece: @piece, promoted: !@promote_trigger, point: @point_from, location: @player.location)
      end
    end

    private

    def read_point
      @point_to = nil
      case
      when @md[:same] == "同"
        if @player.mediator && hand_log = @player.mediator.hand_logs.last
          @point_to = hand_log.point_to
        end
        unless @point_to
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end

        # 記事などで改ページしたとき、明示的に "同２四歩" と書く場合もあるとのこと
        if @md[:point_to]
          prefix_pt = Point.fetch(@md[:point_to])
          if Point.fetch(@md[:point_to]) != @point_to
            raise SamePointDifferent, "同は#{@point_to}を意味しますが明示的に指定した移動先は #{prefix_pt} です : #{@source.inspect}"
          end
        end
      when @md[:point_to]
        @point_to = Point.fetch(@md[:point_to])
      else
        raise SyntaxDefact, "移動先の座標が不明です : #{@source.inspect}"
      end
    end

    # 「７六歩」とした場合「７六歩打」なのか「７六歩(nn)」なのか判断できないので
    # 「７六」に来ることができる歩があれば「７六歩(nn)」と判断する
    # で、「７六」に来ることができる歩 の元の位置を探すのがこのメソッド
    def find_origin_point
      # # 指定の場所に来れる盤上の駒に絞る
      # @battlers = @player.battlers.find_all { |battler| battler.movable_infos.any?{|e|e[:point] == @point_to} }
      # @battlers = @battlers.find_all{|e|e.piece.key == @piece.key} # 同じ駒に絞る
      # @battlers = @battlers.find_all{|e|!!e.promoted == !!@promoted} # 成っているかどうかで絞る
      # @candidate = @battlers.collect{|s|s.clone}

      if @battlers.empty?
        # 「打」を省略している場合、持駒から探す
        if @player.piece_box.exist?(@piece)
          if @promote_trigger
            raise IllegibleFormat, "「２二角打」または「２二角」(打の省略形)とするところを「２二角成打」と書いている系のエラーです : '#{@source.inspect}'"
          end
          @strike_trigger = true
          if @promoted
            raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません: '#{@source.inspect}'"
          end
          battler = Battler.create(player: @player, piece: @player.piece_pick_out(@piece), point: @point_to, promoted: @promoted, location: @player.location)
          @player.put_on_with_valid(battler)
          @player.battlers << battler
          @done = true
        else
          raise MovableBattlerNotFound, "#{@player.location.name}の手番で #{@point_to.name.inspect} の地点に移動できる #{@soldier.any_name.inspect} がありません。入力した #{@source.inspect} がまちがっている可能性があります\n#{@player.mediator}"
        end
      end

      unless @done
        if @battlers.size > 1
          if @md[:motion1]
            # TODO: 入力の正規表現を改めたのでこのチェックは不要かもしれない
            assert_valid_format("直上")
            assert_valid_format("左右直")
            assert_valid_format("寄引上")
            find_battlers
          end
          if @battlers.size > 1
            raise AmbiguousFormatError, "#{@point_to.name}に移動できる駒が複数あります。#{@source.inspect} の表記を明確にしてください。(移動元候補: #{@battlers.collect(&:mark_with_formal_name).join(' ')})\n#{@player.board_with_pieces}"
          end
        end

        # Point[@player.board.surface.invert[@battlers.first]] として引くことも可能だけど遅い
        @point_from = @battlers.first.point
      end
    end

    def find_battlers
      __saved_battlers = @battlers

      # 上下左右は後手なら反転する
      cond = "左右"
      if @md[:motion1].match?(/[#{cond}]/)
        if @piece.brave?
          m = _method([:first, :last], cond)
          @battlers = @battlers.sort_by{|battler|battler.point.x.value}.send(m, 1)
        else
          m = _method([:>, :<], cond)
          @battlers = @battlers.find_all{|battler|@point_to.x.value.send(m, battler.point.x.value)}
        end
      end
      cond = "上引"
      if @md[:motion1].match?(/[#{cond}]/)
        m = _method([:<, :>], cond)
        @battlers = @battlers.find_all{|battler|@point_to.y.value.send(m, battler.point.y.value)}
      end

      # 寄 と 直 は先手後手関係ないので反転する必要なし
      if true
        if @md[:motion1].include?("寄")
          # TODO: 厳密には左右1個分だけチェックする
          @battlers = @battlers.find_all { |e| e.point.y == @point_to.y }
        end

        # 真下にあるもの
        if @md[:motion1].include?("直")
          @battlers = @battlers.find_all { |e|
            e.point.x == @point_to.x &&
            e.point.y.value == @point_to.y.value + @player.location.which_val(1, -1)
          }
        end
      end

      if @battlers.empty?
        raise AmbiguousFormatError, "#{@point_to.name}に移動できる駒がなくなりまりました。#{@source.inspect} の表記を明確にしてください。(移動元候補だったがなくなってしまった駒: #{__saved_battlers.collect(&:mark_with_formal_name).join(', ')})\n#{@player.board_with_pieces}"
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

    def battler_put
      battler = Battler.create(player: @player, piece: @player.piece_pick_out(@piece), promoted: @promoted, point: @point_to, location: @player.location)
      @player.put_on_with_valid(battler)
      @player.battlers << battler
      @done = true
    end

    def point_same?
      if @player.mediator && hand_logs = @player.mediator.hand_logs
        # 自分の手と同じところを見て「同」とやっても結局、自分の駒の上に駒を置くことになってエラーになるのでここは相手を探した方がいい
        # ずっと遡っていくとまた嵌りそうな気がするけどやってみる
        if hand_log = hand_logs.reverse.find { |e| e.player.location != @player.location }
          hand_log.point_to == @point_to
        end
      end
    end
  end
end
