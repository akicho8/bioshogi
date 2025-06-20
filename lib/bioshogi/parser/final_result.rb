module Bioshogi
  module Parser
    class FinalResult
      attr_accessor :last_action_key

      delegate *[
        :win_player_collect_p, # 勝ち負けがついた一般的な終わり方をしたか？
        :last_checkmate_p,     # 詰みまで指したか？
      ], to: :last_action_info, allow_nil: true

      # 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
      def last_action_info
        LastActionInfo[last_action_key] # こっちの方を TORYO をデフォルトにしておく？
      end

      # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
      # "*" のあとにスペースを入れると、激指でコメントの先頭にスペースが入ってしまうため、仕方なくくっつけている
      def illegal_judgement_message
        if v = last_action_key
          unless LastActionInfo[v]
            "本当の結末は「#{v}」だが激指ではこれが入っていると読み込めない"
          end
        end
      end
    end
  end
end
