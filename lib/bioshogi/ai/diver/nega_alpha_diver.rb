module Bioshogi
  module AI
    module Diver
      class NegaAlphaDiver < Base
        def dive(player: params[:current_player], depth: 0, alpha: -SCORE_MAX, beta: SCORE_MAX, hand_route: [])
          tle_verify

          container = player.container

          if depth == 0
            @eval_counter = 0
          end

          if logger
            log = -> s { logger_info_on_depth(s, player: player, depth: depth, hand_route: hand_route) }
          end

          if depth_max <= depth
            @eval_counter += 1

            # score = nil
            # if params[:mate_mode]
            #   if params[:base_player] == player
            #     if player.op.mate_danger?
            #       score = SCORE_MAX
            #     else
            #       score = -SCORE_MAX
            #     end
            #   else
            #     p 0
            #     if player.mate_danger?
            #       score = -SCORE_MAX
            #     else
            #       score = SCORE_MAX
            #     end
            #   end
            # else
            #   score = player.evaluator(params).score
            # end
            score = player.evaluator(params).score

            log["%+d" % score] if log
            return [score, []]
          end

          children = collect_children(player, log)

          if children.empty?
            # 手が一つも生成できなかった場合は詰んでいる
            v = score_max_of(player, depth)
            alpha = -v
            best_pv = [MATE] # 注意。-SCORE_MAX を返すと alpha < v が成立しないため読み筋が返せない。

            log["#{hand_route.collect(&:to_s).join(' ')} のあとで合法手がない(=詰み)"] if log

            # これで詰みが生じた指し手を収集できる
            if f = params[:mate_proc]
              f[player, -alpha, hand_route]
            end

            return [alpha, best_pv]
          end

          best_pv = []
          best_hand = nil

          children.each do |hand|
            # unless hand.legal_hand?(container)
            #   # log["skip: #{hand}"] if log
            #   next
            # end

            log["#{hand}"] if log

            # 玉が取られても相手の玉を取り返せば形勢は互角になる。
            # そうなるとピンチであることに気づかない。
            # だかから玉を取ったかどうかの判定を入れて玉を取った時点で最大の評価値にして探索を打ち切る

            # 非合法手が混っている場合はこのチェックが重要になってくる
            # if hand.king_captured?
            #   raise
            #   # alpha = SCORE_MAX - depth
            #   # best_hand = hand
            #   # best_pv = [best_hand]
            #   return [SCORE_MAX, [hand]]
            # else
            v = nil
            pv = nil
            hand.sandbox_execute(container) do
              v, pv = dive(player: player.opponent_player, depth: depth + 1, alpha: -beta, beta: -alpha, hand_route: hand_route + [hand])
              v = -v
            end

            if alpha < v
              alpha = v
              best_hand = hand
              best_pv = [hand, *pv]
            end

            # 詰将棋のときはすべての手を探すため break してはいけない
            if alpha >= beta
              if params[:mate_mode]
              else
                break
              end
            end
          end

          # unless children_exist
          #   raise BioshogiError, "#{player.call_name}の指し手が一つもありません。すべての駒を取られている可能性があります\n#{container.to_bod}"
          # end

          if best_hand
            log["★確 #{best_hand} (#{alpha}) ---------------------------------------- #{hand_route.collect(&:to_s).join(' ')}"] if log
          end

          [alpha, best_pv]
        end
      end
    end
  end
end
