# frozen-string-literal: true

# 設計がおかしくなっていた原因は、このクラスを DTO として扱っていたことにある。
# last_action_params が「なんでもハッシュ」になっているのも問題である。
# 読み込んだ情報へのアクセスメソッドは、このクラス内に積極的に定義すべき。

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
        @last_action_params = {}
        @header             = Header.new
        @force_preset_info  = nil
        @force_location     = nil
        @force_handicap     = nil
        @player_piece_boxes = Location.inject({}) { |a, e| a.merge(e.key => PieceBox.new) }
        @error_message      = nil
        @sfen_info          = nil
      end

      ################################################################################ 以下すべて読み取りメソッド

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

      # 勝ち負けがついた一般的な終わり方をしたか？
      def win_player_collect_p
        if v = last_action_info
          v.win_player_collect_p
        end
      end

      # 詰みまで指したか？
      def last_checkmate_p
        if v = last_action_info
          v.key == :TSUMI
        end
      end

      # 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
      def last_action_info
        LastActionInfo[last_action_params[:last_action_key]] # こっちの方を TORYO をデフォルトにしておく？
      end

      # 読み込み後の結末
      # nil を返す場合もある
      def last_action_info2
        @last_action_info2 ||= yield_self do
          info = nil
          info ||= illegal_move_last_action_info # 1. エラーなら最優先
          info ||= last_action_info              # 2. 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
          info ||= LastActionInfo.fetch(:TORYO)  # 3. 何もなければ投了にしておく (このあたり正確性よりも、読めないことが問題なので何でもいい)
          info
        end
      end

      # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
      # "*" のあとにスペースを入れると、激指でコメントの先頭にスペースが入ってしまうため、仕方なくくっつけている
      def illegal_judgement_message
        if v = @last_action_params[:last_action_key]
          unless LastActionInfo[v]
            "*本当の結末は「#{v}」だが激指ではこれが入っていると読み込めない\n"
          end
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
