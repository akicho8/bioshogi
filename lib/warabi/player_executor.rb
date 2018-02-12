# frozen-string-literal: true

module Warabi
  class PlayerExecutor
    attr_reader :point
    attr_reader :piece
    attr_reader :point_from
    attr_reader :source
    attr_reader :player
    attr_reader :killed_soldier
    attr_reader :skill_set
    attr_reader :origin_soldier

    include PlayerExecutorHuman

    def initialize(player)
      @player = player
    end

    def execute(str)
      @source = str

      @point           = nil
      @promoted        = nil
      @piece           = nil

      @promote_trigger = nil
      @direct_trigger  = nil

      @point_from      = nil
      @origin_soldier  = nil

      @candidate       = nil
      @killed_soldier  = nil

      @skill_set = SkillSet.new

      @done = false

      @input = InputParser.match!(@source)
      @input = Input.new(@input.named_captures.symbolize_keys)

      pre_transform_for_csa
      pre_transform_for_usi

      if @input[:point_from]
        @input[:point_from] = @input[:point_from].slice(/\d+/)
      end

      begin
        attrs = Soldier.new_with_promoted_attributes(@input[:piece])
        @piece = attrs[:piece]
        @promoted = attrs[:promoted]
      rescue => error
        raise MustNotHappen, {error: error, md: @input, source: @source}.inspect
      end

      read_point

      if true
        # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
        # https://ameblo.jp/written-by-m/entry-10365417107.html
        # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
        # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
        # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
        if @piece.brave?
          if @input[:motion1]
            @input[:motion1] = @input[:motion1].gsub(/行/, "上")
          end
        end
      end

      begin
        # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
        if @input[:motion2].to_s.match?(/不?成|生/) && !@piece.promotable?
          raise NoPromotablePiece, "#{@input[:motion1].inspect} としましたが #{@piece.name.inspect} は裏がないので「成・不成・生」は指定できません : #{@source.inspect}"
        end

        @promote_trigger = (@input[:motion2] == "成")
      end

      @direct_trigger = @input[:motion2].to_s.match?(/[打合]/)

      # 指定の場所に来れる盤上の駒に絞る
      # kif → ki2 変換するときのために @candidate を常に作っとかんといけない

      @soldiers = player.soldiers.find_all do |e|
        e.promoted == @promoted &&                      # 成っているかどうかで絞る
          e.piece.key == @piece.key &&                        # 同じ種類に絞る
          e.moved_list(player.board).any? { |e| e.soldier.point == @point } && # 目的地に来れる
          true
      end
      @candidate = @soldiers.freeze

      if @direct_trigger
        if @promoted
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
        end
        soldier_put_on_process
      else
        if @input[:point_from]
          @point_from = Point.fetch(@input[:point_from])
        end

        unless @point_from
          direct_guess
          point_from_guess
        end

        unless @done
          if true
            source_soldier = player.board.lookup(@point_from)
            if !@promote_trigger
              if source_soldier && source_soldier.promoted && !@promoted
                # 成駒を成ってない状態にして移動しようとした場合は、いったん持駒を確認する
                if player.piece_box.exist?(@piece)
                  @direct_trigger = true
                  @point_from = nil
                  soldier_put_on_process
                else
                  raise PromotedPieceToNormalPiece, "成駒を成ってないときの駒の表記で記述しています。#{@source.inspect}の駒は#{source_soldier.any_name}と書いてください\n#{player.mediator.to_bod}"
                end
              end
            end
          end

          unless @done
            @killed_soldier = player.board.lookup(@point)
            @origin_soldier = player.board.lookup(@point_from)
            player.move_to(@point_from, @point, @promote_trigger)
          end
        end
      end
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :direct_hand => direct_hand,
          :moved_hand  => moved_hand,
          :killed_soldier => @killed_soldier,
          :candidate      => @candidate,
          :point_same     => point_same?, # 前の手と同じかどうかは状況によって変わってしまうためこの時点でさっさと生成しておく
          :skill_set      => @skill_set,
        }).freeze
    end

    def soldier
      @soldier ||= Soldier.create(piece: @piece, promoted: @promoted || @promote_trigger, point: @point, location: player.location)
    end

    def moved_hand
      if origin_soldier
        @moved_hand ||= MoveHand.create(soldier: soldier, origin_soldier: origin_soldier)
      end
    end

    def direct_hand
      unless origin_soldier
        @direct_hand ||= DirectHand.create(soldier: soldier)
      end
    end

    private

    def read_point
      case
      when @input[:same] == "同"
        if hand_log = player.mediator.hand_logs.last
          @point = hand_log.soldier.point
        end
        unless @point
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end

        # 記事などで改ページしたとき、明示的に "同２四歩" と書く場合もあるとのこと
        if @input[:point]
          prefix_pt = Point.fetch(@input[:point])
          if Point.fetch(@input[:point]) != @point
            raise SamePointDifferent, "同は#{@point}を意味しますが明示的に指定した移動先は #{prefix_pt} です : #{@source.inspect}"
          end
        end
      when @input[:point]
        @point = Point.fetch(@input[:point])
      else
        raise SyntaxDefact, "移動先の座標が不明です : #{@source.inspect}"
      end
    end

    def soldier_put_on_process
      soldier = Soldier.create(piece: player.piece_box.pick_out(@piece), promoted: @promoted, point: @point, location: player.location)
      player.board.put_on(soldier, validate: true)
      @done = true
    end

    def point_same?
      if hand_log = player.mediator.hand_logs.last
        hand_log.soldier.point == @point
      end
    end

    def pre_transform_for_csa
      if @input[:csa_basic_name] || @input[:csa_promoted_name]
        if @input[:csa_from] == "00"
          @input[:csa_from] = nil
          @input[:motion2] = "打"
        end

        if @input[:csa_from]
          @input[:point_from] = @input[:csa_from]
        end

        @input[:point] = @input[:csa_to]

        if @input[:csa_basic_name]
          # 普通の駒
          @input[:piece] = Piece.basic_group.fetch(@input[:csa_basic_name]).name
        end

        if @input[:csa_promoted_name]
          # このタイミングで成るのかすでに成っていたのかCSA形式だとわからない
          # だから移動元の駒の情報で判断するしかない
          _piece = Piece.promoted_group.fetch(@input[:csa_promoted_name])

          v = player.board[@input[:point_from]] or raise MustNotHappen
          if v.promoted
            @input[:piece] = v.piece.promoted_name
          else
            @input[:piece] = v.piece.name
            @input[:motion2] = "成"
          end
        end
      end
    end

    def pre_transform_for_usi
      if @input[:usi_to]
        convert = -> s { s.gsub(/[[:lower:]]/) { |s| s.ord - 'a'.ord + 1 } }

        if @input[:usi_piece]
          _piece = Piece.find { |e| e.sfen_char == @input[:usi_piece] } or raise
          @input[:piece] = _piece.name
          @input[:motion2] = "打"
          @input[:point] = convert.call(@input[:usi_to])
        else
          @input[:point_from] = convert.call(@input[:usi_from])
          @input[:point] = convert.call(@input[:usi_to])
          if @input[:usi_promote_trigger] == "+"
            @input[:motion2] = "成"
          end
          v = player.board[@input[:point_from]] or raise MustNotHappen
          @input[:piece] = v.any_name
        end
      end
    end
  end
end
