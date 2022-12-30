module Bioshogi
  module Ai
    module Diver
      # https://ja.wikipedia.org/wiki/Negascout
      class NegaScoutDiver < Base
        def dive(player: params[:current_player], depth: 0, alpha: -SCORE_MAX, beta: SCORE_MAX, hand_route: [])
          tle_verify

          container = player.container

          if depth == 0
            @eval_counter = 0
          end

          if logger
            log = -> s { logger_info_on_depth(s, player: player, depth: depth, hand_route: hand_route) }
          end

          # 一番深く潜ったところで局面を評価する
          if depth_max <= depth
            @eval_counter += 1
            score = player.evaluator(params).score
            log["%+d" % score] if log
            return [score, []]
          end

          children = collect_children(player, log)

          # 再帰を簡潔に記述するため
          recursive = -> hand, alpha2, beta2 {
            # # 玉が取られても相手の玉を取り返せば形勢は互角になる。
            # # そうなるとピンチであることに気づかない。
            # # だかから玉を取ったかどうかの判定を入れて玉を取った時点で最大の評価値にして探索を打ち切る
            if hand.king_captured?
              raise
              # v = SCORE_MAX - depth
              v = SCORE_MAX
              log["#{hand} -> #{v} #{player.location}勝"] if log
              return [v, [hand]]
            else
              log["#{hand}"] if log
              hand.sandbox_execute(container) do
                v, pv = dive(player: player.opponent_player, depth: depth + 1, alpha: alpha2, beta: beta2, hand_route: hand_route + [hand])
                v = -v
                [v, pv]
              end
            end
          }

          # children が空の場合を考慮して初期値を投了級にしておく
          max_v = -score_max_of(player, depth) # 浅いほど評価値を高くして最短で詰ますようにする
          # max_v = -SCORE_MAX # 浅いほど評価値を高くして最短で詰ますようにする
          best_pv = [MATE]      # 一度も更新されなかったら手がないということなので詰んでいる

          # ここはなくてもいいけどベストな手から始めることで枝が減る
          if true
            # 効果的なもの順に並び換える→どうやって？？？
            # children = container.move_ordering(player, children)
            children = children.entries # FIXME: 並び返るために全取得すると遅延評価にした意味がない

            # 最善候補を通常の窓で探索

            # ベストな「合法手」を取得
            hand = nil
            loop do
              hand = children.shift # FIXME: 配列として扱わなければ速くなるかも
              if hand.nil?
                break
              end
              if hand.legal_hand?(container)
                break
              end
            end

            if hand
              v, pv = recursive.(hand, -beta, -alpha)
              max_v = v
              best_pv = [hand, *pv]
              if beta <= v
                return [v, [hand, *pv]]
              end
              if alpha < v
                alpha = v
              end
            end
          end

          children.each do |hand|
            if !hand.legal_hand?(container)
              next
            end

            v, pv = recursive.(hand, -(alpha + 1), -alpha) # null window search
            if beta <= v
              return [v, [hand, *pv]]
            end
            if alpha < v
              alpha = v
              v, pv = recursive.(hand, -beta, -alpha) # 通常の窓で再探索
              if beta <= v
                return [v, [hand, *pv]]
              end
              if alpha < v
                alpha = v
              end
            end

            if max_v < v            # "<=" のなら評価値が同じ場合、後の方を優先する
              max_v = v
              best_pv = [hand, *pv]
            end
          end

          log["★確 #{best_pv.first || '?'}"] if log
          [max_v, best_pv]
        end
      end
    end
  end
end
