module Bioshogi
  module Diver
    # 詰将棋専用
    # ・評価値の大小は関係なく3つの状態しかない
    # ・詰み   → +1
    # ・不詰み → -1
    # ・不明   →  0 (最深度に達っしたときその先はどうなるかわからないため)
    class NegaAlphaMateDiver < Base
      def initialize(*)
        super

        @params[:mate_mode] = true
      end

      def dive(player: params[:current_player], depth: 0, alpha: -SCORE_MAX, beta: +SCORE_MAX, hand_route: [])
        tle_verify

        mediator = player.mediator

        if depth == 0
          @eval_counter = 0
        end

        if logger
          log = -> s { logger_info_on_depth(s, player: player, depth: depth, hand_route: hand_route) }
        end

        if depth_max <= depth
          @eval_counter += 1

          # raise if player.location.key == :white

          # if player.mate_advantage?
          #   if collect_children(player.op, log).empty?
          #     score = 1
          #   else
          #     score = -1
          #   end
          # else
          #   score = -1
          # end

          # if collect_children(player, log).empty?
          #   score = -1
          # else
          #   score = 1
          # end

          # この先は詰みか不詰かわからないため0とする
          score = 0

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
          # score = player.evaluator(params).score

          log["%+d" % score] if log
          # p ["#{__FILE__}:#{__LINE__}", __method__, hand_route]
          return [score, [], []]
        end

        children = collect_children(player, log)

        # @hands_memo[depth] ||= children
        # children = @hands_memo[depth]

        if children.empty?
          # 手が一つも生成できなかった場合は詰んでいる
          # v = score_max_of(player, depth)
          # best_pv = [MATE] # 注意。-SCORE_MAX を返すと alpha < v が成立しないため読み筋が返せない。

          log["#{hand_route.collect(&:to_s).join(' ')} のあとで合法手がない(=詰み)"] if log

          # # これで詰みが生じた指し手を収集できる
          if f = params[:mate_proc]
            f[player, -1, hand_route]
          end

          return [-1, [MATE]]
        end

        best_pv = []
        best_hand = nil
        # children_exist = false

        children.each do |hand|
          # unless hand.legal_hand?(mediator)
          #   # log["skip: #{hand}"] if log
          #   next
          # end
          # children_exist = true

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
          hand.sandbox_execute(mediator) do
            v, pv = dive(player: player.opponent_player, depth: depth + 1, alpha: -beta, beta: -alpha, hand_route: hand_route + [hand])
            log["#{v}, #{pv} = dive"] if log
            v = -v                # 相手が良くなるほどこちらは不利になる
          end

          # if hand_route.first.to_s == "▲１二銀打"
          #   p pv
          #   p v
          #   exit
          # end

          # p [alpha, v]
          log["if #{alpha} < #{v}"] if log
          if alpha < v
            alpha = v
            best_hand = hand
            best_pv = [hand, *pv]
            log["alpha = #{v}"] if log
            log["best_pv = #{best_pv}"] if log
            # best_pv = foo + [hand]
          end

          # if pv.include?(MATE)
          #   onajino << [hand, *pv]
          # end

          # 詰将棋のときはすべての手を探すため break してはいけない
          if alpha >= beta
            log["break if #{alpha} >= #{beta}"] if log
            break
          end
        end

        # if xlist.all?{|e| e >= 1}
        # end

        #   alpha = 1
        # else
        #   alpha = -1
        # end

        # unless children_exist
        #   raise BioshogiError, "#{player.call_name}の指し手が一つもありません。すべての駒を取られている可能性があります\n#{mediator.to_bod}"
        # end

        if best_hand
          log["★確 #{best_hand} (#{alpha}) ---------------------------------------- #{hand_route.collect(&:to_s).join(' ')}"] if log

          # if best_pv.last. == MATE
          #   onajino << [hand, *pv]
          # end
        end

        # p [alpha, best_pv]
        log["return [#{alpha}, #{best_pv}]"] if log
        [alpha, best_pv]
      end

      # # 手を生成
      # def collect_children(player, log)
      #
      #   if params[:base_player].nil?
      #     raise "base_player (攻め手のプレイヤー) を指定してください"
      #   end
      #
      #   if params[:base_player] == player
      #     # 詰将棋モードなら自分だけ王手のみを生成する
      #     v = player.create_all_hands(legal_only: true, mate_only: true).entries
      #     log["王手のみの手を生成: #{v.collect(&:to_s).join(', ')}"] if log
      #     v
      #   else
      #     # 王手を外す手だけを生成する
      #     v = player.create_all_hands(legal_only: true).entries
      #     log["王手解除の手を生成: #{v.collect(&:to_s).join(', ')}"] if log
      #     v
      #   end
      # end
    end
  end
end
