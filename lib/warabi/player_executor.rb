# frozen-string-literal: true

module Warabi
  class PlayerExecutor
    attr_reader :point
    attr_reader :piece
    attr_reader :point_from
    attr_reader :source
    attr_reader :player
    attr_reader :killed_soldier
    attr_reader :origin_soldier

    attr_reader :soldier
    attr_reader :direct_hand
    attr_reader :move_hand

    attr_reader :last_captured_piece

    delegate :board, :piece_box, :mediator, to: :player

    def initialize(player, source)
      @player = player
      @source = source
    end

    def input
      @input ||= -> {
        md = InputParser.match!(@source)
        input_adapter_class(md).new(player, md.named_captures.symbolize_keys)
      }.call
    end

    def execute
      input.perform_validations
      if error = input.errors.first
        raise_error(error)
      end

      @candidate_soldiers = input.candidate_soldiers
      @origin_soldier     = input.origin_soldier
      @soldier            = input.soldier
      @direct_hand        = input.direct_hand
      @move_hand          = input.move_hand
      @killed_soldier     = nil

      if input.direct_trigger
        piece_box.pick_out(@soldier.piece)
        board.put_on(@soldier, validate: true)
      else
        @killed_soldier = board.lookup(@soldier.point)
        move_to(@origin_soldier.point, @soldier.point, input.promote_trigger)
      end
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :direct_hand    => @direct_hand,
          :move_hand      => @move_hand,
          :candidate      => @candidate_soldiers,
          :point_same     => point_same?,
          :skill_set      => skill_set,
          :killed_soldier => @killed_soldier,
        }).freeze
    end

    def skill_set
      @skill_set ||= SkillSet.new
    end

    private

    def move_to(from, to, promote_trigger = false)
      @last_captured_piece = nil

      from = Point.fetch(from)
      to = Point.fetch(to)

      # 破壊的な処理をする前の段階でエラーチェックを行う
      # if true
      #   if promote_trigger
      #     if !from.promotable?(player.location) && !to.promotable?(player.location)
      #       raise NotPromotable, "#{from}から#{to}への移動では成れません"
      #     end
      #
      #     soldier = board.lookup(from)
      #     if soldier.promoted
      #       raise AlredyPromoted, "成りを明示しましたが#{soldier.point}の#{soldier.piece.name}はすでに成っています"
      #     end
      #   end
      #
      #   if (soldier = board.lookup(from)) && player.location != soldier.location
      #     raise ReversePlayerPieceMoveError, "相手の駒を動かそうとしています。#{player.location}の手番で#{soldier}を#{to}に動かそうとしています\n#{mediator.to_bod}"
      #   end
      # end

      # 移動先に相手の駒があれば取って駒台に移動する
      if target_soldier = board.lookup(to)
        # if target_soldier.location == player.location
        #   raise SamePlayerBattlerOverwrideError, "自分の駒を取ろうとしています。移動元:#{from} 対象の駒:#{target_soldier}\n#{mediator.to_bod}"
        # end
        board.pick_up!(to)
        piece_box.add(target_soldier.piece.key => 1)
        mediator.kill_counter += 1
        @last_captured_piece = target_soldier.piece
      end

      from_soldier = board.pick_up!(from)
      attributes = from_soldier.attributes
      if promote_trigger
        attributes[:promoted] = true
      end
      attributes[:point] = to
      board.put_on(Soldier.create(attributes), validate: true)
      # end
    end

    def point_same?
      if hand_log = mediator.hand_logs.last
        hand_log.soldier.point == @soldier.point
      end
    end

    def raise_error(error)
      attributes = {
        "手番"   => player.call_name,
        "指し手" => input.input.values.join,
        "棋譜"   => mediator.hand_logs.collect { |e| e.to_kif(with_mark: true) }.join(" "),
      }

      message = [error[:message]]
      message.concat(attributes.collect { |*e| e.join(": ") })
      message << mediator.to_bod
      message = message.join("\n")

      raise error[:klass].new(message)
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
