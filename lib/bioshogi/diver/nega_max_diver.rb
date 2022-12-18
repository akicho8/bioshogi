module Bioshogi
  module Diver
    # コードはわかりやすいが遅い
    class NegaMaxDiver < Base
      def dive(player: params[:current_player], depth: 0, hand_route: [])
        tle_verify

        container = player.container

        if depth == 0
          @eval_counter = 0
        end

        if logger
          log = -> s { logger_info_on_depth(s, player: player, depth: depth, hand_route: hand_route) }
        end

        # 一番深い局面に達したらはじめて評価する
        if depth_max <= depth
          @eval_counter += 1
          score = player.evaluator(params).score
          log["%+d" % score] if log
          return [score, [], []]
        end

        children = collect_children(player, log)

        if children.empty?
          log["#{hand_route.collect(&:to_s).join(' ')} のあとで合法手がない(=詰み)"] if log
          score = -score_max_of(player, depth)
          if f = params[:mate_proc]
            f[player, score, hand_route + [MATE]]
          end
          return [score, [MATE]]
        end

        max = -score_max_of(player, depth)
        best_pv = [MATE]      # 初期値を詰みにしておくことで children が空のときに詰みが返る

        children.each do |hand|
          hand.sandbox_execute(container) do
            log["#{hand}"] if log
            v, pv = dive(player: player.opponent_player, depth: depth + 1, hand_route: hand_route + [hand])
            v = -v # 相手の一番良い手は自分の一番悪い手としたいので符号を反転する
            if v > max
              best_pv = [hand, *pv]
              max = v
            end
          end
        end

        [max, best_pv]
      end
    end
  end
end
