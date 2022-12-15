# frozen-string-literal: true

module Bioshogi
  module Parser
    class Mi
      attr_accessor :move_infos
      attr_accessor :first_comments
      attr_accessor :board_source
      attr_accessor :last_action_params
      attr_accessor :header
      attr_accessor :force_preset_info
      attr_accessor :force_location
      attr_accessor :force_handicap
      attr_accessor :player_piece_boxes

      def initialize
        @move_infos         = []
        @first_comments     = []
        @board_source       = nil
        @last_action_params = nil
        @header             = Header.new
        @force_preset_info  = nil
        @force_location     = nil
        @force_handicap     = nil
        @player_piece_boxes = Location.inject({}) { |a, e| a.merge(e.key => PieceBox.new) }
      end
    end
  end
end
