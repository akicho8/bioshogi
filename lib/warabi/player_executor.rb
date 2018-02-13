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
      @input = @input.named_captures.symbolize_keys
      case
      when @input[:csa_basic_name] || @input[:csa_promoted_name]
        adapter = CsaAdapter
      when @input[:usi_to]
        adapter = UsiAdapter
      when @input[:point_from]
        adapter = KifAdapter
      else
        adapter = Ki2Adapter
      end
      @input2 = adapter.new(player, @input).tap(&:run)

      @piece = @input2.piece
      @promoted = @input2.promoted

      point_fetch_process

      # この例外を入れると入力が正確になるだけなので、まー無くてもいい。"１三金不成" で入力しても "１三金" の棋譜になるので。
      if @input2.promote_arinashi_sitei_ari && !@piece.promotable?
        raise NoPromotablePiece, "#{@piece}は裏がないので「成・不成・生」は指定できません : #{@source.inspect}"
      end

      @promote_trigger = @input2.promote_trigger
      @direct_trigger = @input2.direct_trigger

      assert_no_promoted_piece_put_on_error

      # 指定の場所に来れる盤上の駒に絞る
      # kif → ki2 変換するときのために @candidate を常に作っとかんといけない
      @soldiers = player.soldiers.find_all do |e|
        e.promoted == @promoted &&                      # 成っているかどうかで絞る
          e.piece.key == @piece.key &&                        # 同じ種類に絞る
          e.move_list(player.board).any? { |e| e.soldier.point == @point } && # 目的地に来れる
          true
      end
      @candidate = @soldiers.freeze

      if @direct_trigger
        soldier_put_on_process
      else
        @point_from = @input2.point_from

        unless @point_from
          # KI2 の場合のみ
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
          :direct_hand    => direct_hand,
          :moved_hand     => moved_hand,
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

    def point_fetch_process
      case
      when @input2.same?
        if hand_log = player.mediator.hand_logs.last
          @point = hand_log.soldier.point
        end
        unless @point
          raise BeforePointNotFound, "同に対する座標が不明です : #{@source.inspect}"
        end

        # 記事などで改ページしたとき、明示的に "同２四歩" と書く場合もあるとのこと
        if v = @input2.point
          if v != @point
            raise SamePointDifferent, "同は#{@point}を意味しますが明示的に指定した移動先は#{v}です : #{@source.inspect}"
          end
        end
      when v = @input2.point
        @point = v
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

    def assert_no_promoted_piece_put_on_error
      if @direct_trigger && @promoted
        raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません : #{@source.inspect}"
      end
    end

    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|
    # >> | source     | triangle | point | same | piece | motion_part | trigger_part | point_from | sign | csa_from | csa_to | csa_basic_name | csa_promoted_name | usi_direct_piece | usi_direct | usi_to | usi_from | usi_promote_trigger |
    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|
    # >> | ６八銀左   |          | ６八  |      | 銀    | 左          |              |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | △６八全   | △       | ６八  |      | 全    |             |              |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | △６八銀成 | △       | ６八  |      | 銀    |             | 成           |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | △６八銀打 | △       | ６八  |      | 銀    |             | 打           |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | △同銀     | △       |       | 同   | 銀    |             |              |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | △同銀成   | △       |       | 同   | 銀    |             | 成           |            |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | ７六歩(77) |          | ７六  |      | 歩    |             |              | (77)       |      |          |        |                |                   |                  |            |        |          |                     |
    # >> | 7677FU     |          |       |      |       |             |              |            |      |       76 |     77 | FU             |                   |                  |            |        |          |                     |
    # >> | -7677FU    |          |       |      |       |             |              |            | -    |       76 |     77 | FU             |                   |                  |            |        |          |                     |
    # >> | +0077RY    |          |       |      |       |             |              |            | +    |       00 |     77 |                | RY                |                  |            |        |          |                     |
    # >> | 8c8d       |          |       |      |       |             |              |            |      |          |        |                |                   |                  |            | 8d     | 8c       |                     |
    # >> | P*2f       |          |       |      |       |             |              |            |      |          |        |                |                   | P                | *          | 2f     |          |                     |
    # >> | 4e5c+      |          |       |      |       |             |              |            |      |          |        |                |                   |                  |            | 5c     | 4e       | +                   |
    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|

    class Adapter
      class << self
        def run(*args)
          new(*args).tap(&:run)
        end
      end

      attr_reader :player
      attr_reader :input

      def initialize(player, input)
        @player = player
        @input = input
      end

      # 同
      def same?
        false
      end

      # 成や不成の指示があるか？
      def promote_arinashi_sitei_ari
        false
      end
    end

    class KifAdapter < Adapter
      attr_reader :piece
      attr_reader :promoted

      def run
        hash = Soldier.piece_and_promoted(@input[:piece])
        @piece = hash[:piece]
        @promoted = hash[:promoted]
      end

      def point_from
        if v = @input[:point_from]
          Point.fetch(@input[:point_from].slice(/\d+/))
        end
      end

      def point
        if v = @input[:point]
          Point.fetch(v)
        end
      end

      def same?
        @input[:same] == "同"
      end

      def promote_trigger
        @input[:trigger_part] == "成"
      end

      def direct_trigger
        @input[:trigger_part].to_s.match?(/[打合]/)
      end

      def location
        if v = @input[:triangle]
          Location.fetch(v)
        end
      end

      def promote_arinashi_sitei_ari
        if s = @input[:trigger_part]
          s.match?(/不?成|生/)
        end
      end
    end

    class Ki2Adapter < KifAdapter
      # ▼将棋のルール「棋譜について」｜品川将棋倶楽部
      # https://ameblo.jp/written-by-m/entry-10365417107.html
      # > どちらの飛車も１三の地点に移動できます。よって、それぞれの駒が１三の地点に移動する場合は、
      # > 上の駒は▲１三飛引成（成らない場合は▲１三飛引不成）。下の駒は▲１三飛上成（あがるなり）と表記します。
      # > 飛車や角に限り「行」を用いて▲１三飛行成（いくなり）と表記することもあります。
      def motion_part
        if s = @input[:motion_part]
          if piece.brave?
            s = s.tr("行", "上")
          end
          s
        end
      end
    end

    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+-----------+-------------+--------+----------+---------------------|
    # >> | source     | triangle | point | same | piece | motion_part | trigger_part | point_from | sign | csa_from | csa_to | csa_basic_name | csa_promoted_name | usi_direct_piece | usi_direct | usi_to | usi_from | usi_promote_trigger |
    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+-----------+-------------+--------+----------+---------------------|
    # >> | ６八銀左   |          | ６八  |      | 銀    | 左          |              |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | △６八全   | △       | ６八  |      | 全    |             |              |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | △６八銀成 | △       | ６八  |      | 銀    |             | 成           |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | △６八銀打 | △       | ６八  |      | 銀    |             | 打           |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | △同銀     | △       |       | 同   | 銀    |             |              |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | △同銀成   | △       |       | 同   | 銀    |             | 成           |            |      |          |        |                |                   |           |             |        |          |                     |
    # >> | ７六歩(77) |          | ７六  |      | 歩    |             |              | (77)       |      |          |        |                |                   |           |             |        |          |                     |
    # >> | 7677FU     |          |       |      |       |             |              |            |      |       76 |     77 | FU             |                   |           |             |        |          |                     |
    # >> | -7677FU    |          |       |      |       |             |              |            | -    |       76 |     77 | FU             |                   |           |             |        |          |                     |
    # >> | +0077RY    |          |       |      |       |             |              |            | +    |       00 |     77 |                | RY                |           |             |        |          |                     |
    # >> | 8c8d       |          |       |      |       |             |              |            |      |          |        |                |                   |           |             | 8d     | 8c       |                     |
    # >> | P*2f       |          |       |      |       |             |              |            |      |          |        |                |                   | P         | *           | 2f     |          |                     |
    # >> | 4e5c+      |          |       |      |       |             |              |            |      |          |        |                |                   |           |             | 5c     | 4e       | +                   |
    # >> |------------+----------+-------+------+-------+-------------+--------------+------------+------+----------+--------+----------------+-------------------+-----------+-------------+--------+----------+---------------------|

    class CsaAdapter < Adapter
      attr_reader :piece
      attr_reader :promoted
      attr_reader :promote_trigger

      def run
        @promote_trigger = false

        if v = @input[:csa_basic_name]
          @piece = Piece.basic_group.fetch(v)
          @promoted = false
        elsif v = @input[:csa_promoted_name]
          # このタイミングで成るのかすでに成っていたのかCSA形式だとわからないので移動元の駒の情報で判断する
          @piece = Piece.promoted_group.fetch(v)
          @promoted = true

          origin_soldier = player.board[point_from]
          # 成っていなかった
          if !origin_soldier.promoted
            @promote_trigger = true # FIXME: 別に求めないでいいのでは？
          end
        else
          raise
        end
      end

      def point_from
        v = @input[:csa_from]
        if v != "00"
          Point.fetch(v)
        end
      end

      def point
        Point.fetch(@input[:csa_to])
      end

      def direct_trigger
        @input[:csa_from] == "00"
      end
    end

    class UsiAdapter < Adapter
      attr_reader :piece
      attr_reader :promoted

      def run
        if v = @input[:usi_direct_piece]
          @piece = Piece.fetch(v) # 打つ駒
          @promoted = false
        else
          # 求めなくてもよい？
          soldier = player.board.surface.fetch(point_from)
          @piece = soldier.piece
          @promoted = soldier.promoted
        end
      end

      def point_from
        if v = @input[:usi_from]
          Point.fetch(alpha_to_digit(v))
        end
      end

      def point
        v = @input[:usi_to]
        Point.fetch(alpha_to_digit(v))
      end

      def direct_trigger
        @input[:usi_direct] == "*"
      end

      def promote_trigger
        @input[:usi_promote_trigger] == "+"
      end

      private

      def alpha_to_digit(s)
        s.gsub(/[[:lower:]]/) { |s| s.ord - 'a'.ord + 1 }
      end
    end
  end
end
