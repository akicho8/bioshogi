# frozen-string-literal: true

module Bioshogi
  module Parser
    class Pi
      # 読み取り結果
      attr_accessor :move_infos
      attr_accessor :first_comments
      attr_accessor :board_source
      attr_accessor :last_action_params
      attr_accessor :header
      attr_accessor :force_preset_info
      attr_accessor :force_location
      attr_accessor :force_handicap
      attr_accessor :player_piece_boxes
      attr_accessor :sfen_info

      # 変換時に必要なもの
      attr_accessor :error_message

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
        @error_message      = nil
        @sfen_info          = nil
      end

      def clock_exist?
        return @clock_exist if instance_variable_defined?(:@clock_exist)
        @clock_exist ||= @move_infos.any? { |e| e[:used_seconds].to_i.nonzero? }
      end

      def clock_nothing?
        !clock_exist?
      end

      # 勝ち負けがついた一般的な終わり方をしたか？
      def win_player_collect_p
        return @win_player_collect_p if instance_variable_defined?(:@win_player_collect_p)

        @win_player_collect_p ||= yield_self do
          if last_action_params
            if last_action_key = last_action_params[:last_action_key]
              if last_action_info = Formatter::LastActionInfo[last_action_key]
                last_action_info.win_player_collect_p
              end
            end
          end
        end
      end

      # 詰みまで指したか？
      def last_checkmate_p
        return @last_checkmate_p if instance_variable_defined?(:@last_checkmate_p)

        @last_checkmate_p ||= yield_self do
          if last_action_params
            if last_action_key = last_action_params[:last_action_key]
              if last_action_info = Formatter::LastActionInfo[last_action_key]
                last_action_info.key == :TSUMI
              end
            end
          end
        end
      end
    end
  end
end
