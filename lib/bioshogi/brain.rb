# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/brain_spec.rb" -*-
# frozen-string-literal: true

require "timeout"

module Bioshogi
  SCORE_MAX = 999999      # Float::INFINITY を使うとおかしくなるので注意
  MATE = "(詰み)"

  # 指定の Diver を使って簡単に反復探索するためのクラス
  class Brain
    def self.human_format(infos)
      infos.collect.with_index do |e, i|
        {
          "順位"       => i.next,
          "候補手"     => e[:hand],
          "読み筋"     => e[:best_pv].collect(&:to_s).join(" "),
          "▲形勢"     => e[:black_side_score], # 先手視点の評価値
          "評価局面数" => e[:eval_times],
          "処理時間"   => e[:sec],
          # "他の手"     => e[:other].collect { |a| a.collect(&:to_s).join(" ") }.join(", ")
        }
      end
    end

    attr_accessor :player, :params

    delegate :mediator, :create_all_hands, to: :player
    delegate :logger, :to => "Bioshogi", allow_nil: true

    def initialize(player, **params)
      @player = player
      @params = {
        diver_class: Diver::NegaAlphaDiver,    # [Diver::NegaAlphaDiver, Diver::NegaScoutDiver]
        evaluator_class: Evaluator::Level1, # [Evaluator::Base, Evaluator::Level1, Evaluator::Level2, Evaluator::Level3]

        # legal_moves_all: false,         # すべての手を合法手に絞る(重い！)
        # legal_moves_first_only: true,   # 最初の手だけ合法手に絞る
      }.merge(params)
    end

    # ショートカット用
    def diver_dive(**params)
      diver_instance(params.merge(current_player: player)).dive
    end

    # 反復深化深さ優先探索
    # https://ja.wikipedia.org/wiki/%E5%8F%8D%E5%BE%A9%E6%B7%B1%E5%8C%96%E6%B7%B1%E3%81%95%E5%84%AA%E5%85%88%E6%8E%A2%E7%B4%A2
    # > ゲーム木でIDDFSを使う場合、アルファ・ベータ枝刈りなどのヒューリスティックが反復によって改善されていき、
    # > 最も深い探索でのスコアの推定値がより正確になるという利点がある。また、探索順序を改善することができるため、
    # > 探索をより高速に行えるという利点もある（前の反復で最善とされた手を次の反復で最初に調べることでアルファ・ベータ法の効率が良くなる）。
    def iterative_deepening(**params)
      # このパラメータはそのまま Diver に渡している
      params = {
        depth_max_range: 1..1,  # 1..3 なら時間がある限り1→2→3手と読み進めていく。3手詰限定なら 3..3 とする
        time_limit: nil,        # nil なら時間制限なし。時間指定なしなら 深度を を 1..3 のようにする意味はなくて最初から 3..3 とすればよい
        mate_mode: false,       # 王手になる手と、王手をかわす手だけを生成するか？

        # 常に diver_instance に渡すもの
        base_player: player,    # どちらのプレイヤーから開始したか。詰将棋のときなど先後で指し手の方針を明確に分ける必要があるため。
        current_player: player.opponent_player, # Diver#dive の最初の player として使うため
      }.merge(params)

      if params[:time_limit]
        params[:time_limit_exceeded] ||= Time.now + params[:time_limit]
      end

      if params[:mate_mode]
        children = player.create_all_hands(legal_only: true, mate_only: true) # 王手になる手だけを生成
      else
        children = player.create_all_hands(legal_only: true)
      end

      # if true
      #   # あまりに重いので読みの最初の手を合法手に絞る
      #   children = children.find_all { |e| e.legal_hand?(mediator) }
      # else
      #   children = children.to_a # 何度も実行するためあえて配列化しておくの重要
      # end

      # ordered_children = children # 前の反復で最善とされた順に並んでいる手

      hands = []
      provisional_hands = []
      mate = false
      finished = catch :time_limit_exceeded do
        params[:depth_max_range].each do |depth_max|
          diver = diver_instance(params.merge(depth_max: depth_max))

          provisional_hands = []
          mate = false
          children.each do |hand|
            logger.debug "#ROOT #{hand}" if logger

            # 即詰があれば探索を速攻打ち切る場合
            # 無効にしてもいいけど他の探索で時間がかかったら、この深さの探索全体がTLEでキャンセルされる可能性がある
            # if true
            #   if hand.king_captured?
            #     v = -SCORE_MAX
            #     provisional_hands << {hand: hand, score: -v, black_side_score: -v * player.location.value_sign, best_pv: [], eval_times: 0, sec: 0}
            #     mate = true
            #     break
            #   end
            # end

            hand.sandbox_execute(mediator) do
              start_time = Time.now
              v, pv = diver.dive(hand_route: [hand]) # TLEが発生してするとcatchまで飛ぶ
              v = -v                                        # 相手の良い手は自分のマイナス
              provisional_hands << {hand: hand, score: v, black_side_score: v * player.location.value_sign, best_pv: pv, eval_times: diver.eval_counter, sec: Time.now - start_time}
              # 1手詰: (v >= SCORE_MAX - 0) 自分勝ち
              # 2手詰: (v >= SCORE_MAX - 1) 相手勝ち
              # 3手詰: (v >= SCORE_MAX - 2) 自分勝ち
              # 4手詰: (v >= SCORE_MAX - 3) 相手勝ち
              # 5手詰: (v >= SCORE_MAX - 4) 自分勝ち
              if v >= SCORE_MAX
                mate = true     # 1手詰があった
              end
            end
            # if hand.king_captured?
            #   mate = true       # 即詰がある
            # end
          end
          hands = provisional_hands

          if true
            hands = hands.sort_by { |e| -e[:score] } # 最善手順に並び換えて採用(途中でbreakするのは詰みがあったときぐらいなのであんまり効果ないかも)
          end

          if mate
            break     # この深さで詰みを発見したらこれ以上は潜らない
          end

          # 次の反復では前の反復で最善とされた順で探索する
          children = hands.collect { |e| e[:hand] }
        end
        true
      end # catch

      if finished
        # すべての探索を終えた
      else
        # タイムアウトしてきた

        # 詰みがあった場合は最後の provisional_hands を採用する
        if mate
          hands = provisional_hands.sort_by { |e| -e[:score] } # 最善手順に並び換えて採用
        end
      end

      # 自分の合法手があるのに相手の手を1手も見つけられない状況
      # TLEが早過ぎる場合に起きる
      if !children.empty? && hands.empty?
        raise BrainProcessingHeavy, "合法手を生成したにもかかわらず、指し手の候補を絞れません。制限時間を増やすか読みの深度を浅くしてください : #{params}"
      end

      hands
    end

    def diver_instance(args)
      params[:diver_class].new(params.merge(args))
    end

    # Board.promotable_disable
    # Board.dimensiton_change([2, 5])
    # mediator = Mediator.new
    # mediator.board.placement_from_shape <<~EOT
    # +------+
    # | ・v香|
    # | ・v飛|
    # | ・v歩|
    # | ・ 飛|
    # | ・ 香|
    # +------+
    # EOT
    # brain = mediator.player_at(:black).brain(evaluator_class: Evaluator::Level2)
    # brain.smart_score_list(depth_max: 2) # => [{:hand=><▲２四飛(14)>, :score=>105, :socre2=>105, :best_pv=>[<△１四歩(13)>, <▲１四飛(24)>], :eval_times=>12, :sec=>0.002647}, {:hand=><▲１三飛(14)>, :score=>103, :socre2=>103, :best_pv=>[<△１三飛(12)>, <▲１三香(15)>], :eval_times=>9, :sec=>0.001463}]
    #
    # 探索するけど探索の深さを延していかない
    def smart_score_list(**params)
      diver = diver_instance(current_player: player.opponent_player)
      create_all_hands(promoted_only: true).collect { |hand|
        hand.sandbox_execute(mediator) do
          start_time = Time.now
          v, pv = diver.dive
          {hand: hand, score: -v, socre2: -v * player.location.value_sign, best_pv: pv, eval_times: diver.eval_counter, sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end

    # すべての手を指してみて評価する (探索しない)
    def fast_score_list(**params)
      evaluator = player.evaluator(params.merge(params))
      create_all_hands(promoted_only: true).collect { |hand|
        hand.sandbox_execute(mediator) do
          start_time = Time.now
          v = evaluator.score
          {hand: hand, score: v, socre2: v * player.location.value_sign, best_pv: [], eval_times: 1, sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end
  end
end
