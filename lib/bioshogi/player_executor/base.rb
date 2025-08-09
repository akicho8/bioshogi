# frozen-string-literal: true

module Bioshogi
  module PlayerExecutor
    class Base
      attr_reader :player
      attr_reader :source
      attr_reader :params

      attr_reader :hand
      attr_reader :drop_hand
      attr_reader :move_hand

      delegate :board, :piece_box, :container, to: :player
      delegate :origin_soldier, :captured_soldier, to: :move_hand, allow_nil: true
      delegate :soldier, to: :hand
      delegate :motion_key, to: :input

      def initialize(player, source, params = {})
        @player = player
        @source = source
        @params = {}.merge(params)
      end

      def input
        @input ||= yield_self do
          md = InputParser.match!(@source)
          input_adapter_class(md).new(player, md.named_captures.symbolize_keys, @source)
        end
      end

      def perform_validations
        unless container.params[:validate_feature]
          return
        end

        input.perform_validations
        if error = input.errors.first
          ErrorHandler.new(self, error).call
        end
      end

      def execute
        perform_validations

        # hand.execute で board が変化してしまうため実行するまえに取得しておく
        # ただし candidate_soldiers は重いので to_ki2 しないのであれば呼ばない方がいい
        @hand               = input.hand
        @drop_hand          = input.drop_hand
        @move_hand          = input.move_hand
        @candidate_soldiers = nil
        if container.params[:ki2_function]
          @candidate_soldiers = input.candidate_soldiers
        end

        hand.execute(container)
        execute_after_process

        if captured_soldier
          piece_box_added
        end

        if move_hand
          move_hand_process
        end

        perform_analyzer

        clock_add_process
        turn_ended_process

        container.turn_info.turn_offset += 1

        turn_changed_process

        hand
      end

      def execute_after_process
      end

      def piece_box_added
      end

      def move_hand_process
        if move_hand.soldier.piece.key == :king
          player.king_place = move_hand.soldier.place
        end
      end

      def clock_add_process
      end

      def turn_ended_process
      end

      def perform_analyzer
      end

      def turn_changed_process
      end

      private

      def input_adapter_class(md)
        case
        when md[:kif_place_from]
          InputAdapter::KifAdapter
        when md[:sfen_to]
          InputAdapter::SfenAdapter
        when md[:csa_piece]
          InputAdapter::CsaAdapter
        else
          InputAdapter::Ki2Adapter
        end
      end

      def tag_bundle
      end
    end
  end
end
