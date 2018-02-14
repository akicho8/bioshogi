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

    def initialize(player, source)
      @player = player
      @source = source

      @promote_trigger = nil
      @direct_trigger  = nil

      @point_from      = nil
      @origin_soldier  = nil

      @killed_soldier  = nil
      @skill_set       = SkillSet.new

      @done            = false
    end

    def input
      @input ||= -> {
        md = InputParser.match!(@source)
        input_adapter_class(md).run(player, md.named_captures.symbolize_keys)
      }.call
    end

    def execute
      @piece = input.piece
      @promoted = input.promoted # 後の状態。「２三歩成」の場合は「２四歩」の状態(=false)ではなく「２三ふ」の状態(=true)
      @point = input.point

      @promote_trigger = input.promote_trigger
      @direct_trigger = input.direct_trigger

      @candidate = candidate_soldiers
      @soldiers = @candidate

      if @direct_trigger
        soldier_direct_put_on_process
      else
        @point_from = input.point_from

        # 移動元がない場合は「打」を省略していると考える
        if !@point_from
          if @soldiers.empty?
            ki2_assert_direct_trigger
            @direct_trigger = true
            soldier_direct_put_on_process
          end
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
                  soldier_direct_put_on_process
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
      @soldier ||= Soldier.create(piece: @piece, promoted: @promoted, point: @point, location: player.location)
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

    def soldier_direct_put_on_process
      soldier = Soldier.create(piece: player.piece_box.pick_out(@piece), promoted: @promoted, point: @point, location: player.location)
      player.board.put_on(soldier, validate: true)
      @done = true
    end

    def point_same?
      if hand_log = player.mediator.hand_logs.last
        hand_log.soldier.point == @point
      end
    end

    # @promote_trigger, @piece, @point が必要
    def candidate_soldiers
      if @promote_trigger
        before_promoted = false
      else
        before_promoted = @promoted
      end
      player.soldiers.find_all do |e|
        e.promoted == before_promoted &&                      # 成っているかどうかで絞る
          e.piece.key == @piece.key &&                        # 同じ種類に絞る
          e.move_list(player.board).any? { |e| e.soldier.point == @point } && # 目的地に来れる
          true
      end
    end

    def input_adapter_class(md)
      case
      when md[:kif_point_from]
        InputAdapter::KifAdapter
      when md[:usi_to]
        InputAdapter::UsiAdapter
      when md[:csa_piece]
        InputAdapter::CsaAdapter
      else
        InputAdapter::Ki2Adapter
      end
    end
  end
end
