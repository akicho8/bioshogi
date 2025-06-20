# frozen-string-literal: true

# 設計がおかしくなっていた原因は、このクラスを DTO として扱っていたことにある。
# last_action_key が「なんでもハッシュ」になっているのも問題である。
# 読み込んだ情報へのアクセスメソッドは、このクラス内に積極的に定義すべき。

module Bioshogi
  module Parser
    class Pi
      # 読み取り結果
      attr_accessor :move_infos
      attr_accessor :first_comments
      attr_accessor :board_source

      attr_accessor :final_result
      attr_accessor :last_used_seconds

      attr_accessor :header
      attr_accessor :force_preset_info
      attr_accessor :force_location
      attr_accessor :force_handicap
      attr_accessor :player_piece_boxes
      attr_accessor :sfen_info

      attr_accessor :error_message

      def initialize
        @move_infos         = []
        @first_comments     = []
        @board_source       = nil

        @final_result       = FinalResult.new
        @last_used_seconds  = nil

        @header             = Header.new
        @force_preset_info  = nil
        @force_location     = nil
        @force_handicap     = nil
        @player_piece_boxes = Location.inject({}) { |a, e| a.merge(e.key => PieceBox.new) }
        @error_message      = nil
        @sfen_info          = nil
      end

      ################################################################################ 以下すべて読み取りメソッド

      def to_h
        instance_variables.inject({}) do |a, e|
          a.merge(e => instance_variable_get(e))
        end
      end

      def used_seconds_at(index)
        @move_infos.dig(index, :used_seconds).to_i
      end

      def clock_exist?
        unless defined?(@clock_exist_p)
          @clock_exist_p = @move_infos.any? { |e| e[:used_seconds].to_i.nonzero? }
        end

        @clock_exist_p
      end

      def clock_nothing?
        !clock_exist?
      end

      # 出力するときの結末
      # nil を返す場合もある
      def output_last_action_info
        @output_last_action_info ||= yield_self do
          info = nil
          info ||= illegal_move_last_action_info # 1. エラーなら最優先
          info ||= final_result.last_action_info # 2. 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
          info ||= LastActionInfo.fetch(:TORYO)  # 3. 何もなければ投了にしておく (このあたり正確性よりも、読めないことが問題なので何でもいい)
          info
        end
      end

      def error_message_part(comment_mark = "*")
        if v = @error_message
          v = v.strip + "\n"
          s = "-" * 76 + "\n"
          [s, *v.lines, s].collect { |e| "#{comment_mark} #{e}" }.join
        end
      end

      private

      def illegal_move_last_action_info
        if @error_message
          LastActionInfo.fetch(:ILLEGAL_MOVE)
        end
      end
    end
  end
end
