# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/brain_spec.rb" -*-
# frozen-string-literal: true

require "timeout"

module Bioshogi
  INF_MAX = 999999      # Float::INFINITY を使うとおかしくなるので注意

  class Brain
    def self.human_format(infos)
      infos.collect.with_index do |e, i|
        {
          "順位"       => i.next,
          "候補手"     => e[:hand],
          "読み筋"     => e[:best_pv].collect { |e| e.to_s }.join(" "),
          "▲形勢"     => e[:score2], # 先手視点の評価値
          "評価局面数" => e[:eval_times],
          "処理時間"   => e[:sec],
        }
      end
    end

    attr_accessor :player, :iparams

    delegate :mediator, :normal_all_hands, to: :player

    def initialize(player, **iparams)
      @player = player
      @iparams = {
        diver_class: NegaAlphaDiver,    # [NegaAlphaDiver, NegaScoutDiver]
        evaluator_class: Evaluator::Base, # [Evaluator::Base, Evaluator::Level1, Evaluator::Level2, Evaluator::Level3]

        # legal_moves_all: false,         # すべての手を合法手に絞る(重い！)
        # legal_moves_first_only: true,   # 最初の手だけ合法手に絞る
      }.merge(iparams)
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
      params = {
        depth_max_range: 1..1,
        time_limit: nil,        # nil: 時間制限なし
      }.merge(params)

      if params[:time_limit]
        params[:out_of_time] ||= Time.now + params[:time_limit]
      end

      children = normal_all_hands

      if true
        # あまりに重いので読みの最初の手を合法手に絞る
        children = children.find_all { |e| e.legal_move?(mediator) }
      else
        children = children.to_a # 何度も実行するためあえて配列化しておくの重要
      end

      # ordered_children = children # 前の反復で最善とされた順に並んでいる手

      hands = []
      tmp_hands = []
      mate = false
      finished = catch :out_of_time do
        params[:depth_max_range].each do |depth_max|
          diver = diver_instance(params.merge(current_player: player.opponent_player, depth_max: depth_max))
          tmp_hands = []
          mate = false
          children.each do |hand|
            Bioshogi.logger.debug "#ROOT #{hand}" if Bioshogi.logger

            # 即詰があれば探索を速攻打ち切る場合
            # 無効にしてもいいけど他の探索で時間がかかったら、この深さの探索全体がTLEでキャンセルされる可能性がある
            # if true
            #   if hand.king_captured?
            #     v = -INF_MAX
            #     tmp_hands << {hand: hand, score: -v, score2: -v * player.location.value_sign, best_pv: [], eval_times: 0, sec: 0}
            #     mate = true
            #     break
            #   end
            # end

            hand.sandbox_execute(mediator) do
              start_time = Time.now
              v, pv = diver.dive # ここで TLE 発生
              v = -v
              tmp_hands << {hand: hand, score: v, score2: v * player.location.value_sign, best_pv: pv, eval_times: diver.eval_counter, sec: Time.now - start_time}
              # 1手詰: (v >= INF_MAX - 0)
              # 3手詰: (v >= INF_MAX - 2)
              # 5手詰: (v >= INF_MAX - 4)
              if v >= INF_MAX
                mate = true     # 1手詰があった
              end
            end
            # if hand.king_captured?
            #   mate = true       # 即詰がある
            # end
          end
          hands = tmp_hands
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

        # 詰みがあった場合は最後の tmp_hands を採用する
        if mate
          hands = tmp_hands.sort_by { |e| -e[:score] } # 最善手順に並び換えて採用
        end
      end

      if !children.empty? && hands.empty?
        raise BrainProcessingHeavy, "合法手を生成したにもかかわらず、指し手の候補を絞れません。制限時間を増やすか読みの深度を浅くしてください : #{params}"
      end

      hands
    end

    def diver_instance(args)
      iparams[:diver_class].new(iparams.merge(args))
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
    def smart_score_list(**params)
      diver = diver_instance(current_player: player.opponent_player)
      normal_all_hands.collect { |hand|
        hand.sandbox_execute(mediator) do
          start_time = Time.now
          v, pv = diver.dive
          {hand: hand, score: -v, socre2: -v * player.location.value_sign, best_pv: pv, eval_times: diver.eval_counter, sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end

    def fast_score_list(**params)
      evaluator = player.evaluator(iparams.merge(params))
      normal_all_hands.collect { |hand|
        hand.sandbox_execute(mediator) do
          start_time = Time.now
          v = evaluator.score
          {hand: hand, score: v, socre2: v * player.location.value_sign, best_pv: [], eval_times: 1, sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end
  end

  class HandInfo < Hash
    def to_s
      "#{self[:hand]} => #{self[:score]}"
    end
  end

  class Diver
    attr_accessor :iparams
    attr_accessor :eval_counter

    # delegate :mediator, to: :player
    # delegate :evaluate, to: :mediator
    # delegate :place_on, to: :mediator

    def initialize(iparams)
      @iparams = {
        depth_max: 0,           # 最大の深さ
        log_skip_depth: nil,
      }.merge(iparams)

      @eval_counter = 0
      # @hands_memo = {}
    end

    private

    def logger_info(str, context)
      return unless logger

      if v = iparams[:log_skip_depth]
        if context[:depth] >= v
          return
        end
      end

      str = str.lines.collect { |e|
        (" " * 4 * context[:depth]) + e
      }.join.rstrip

      if str.match?(/\n/)
        str = "\n" + str
      end

      Bioshogi.logger.info "    %d %s %s" % [
        context[:depth],
        context[:player].location,
        str,
      ]
    end

    def logger
      Bioshogi.logger
    end

    def out_of_time_check
      if time = iparams[:out_of_time]
        if time && time <= Time.now
          throw :out_of_time
        end
      end
    end

    def depth_max
      iparams[:depth_max]
    end

    # 深いほど手がかかるので最大の評価値を下げる
    def score_max_for(depth)
      INF_MAX - depth
    end
  end

  class NegaAlphaDiver < Diver
    def dive(player = iparams[:current_player], depth = 0, alpha = -INF_MAX, beta = INF_MAX)
      out_of_time_check

      mediator = player.mediator

      if depth == 0
        @eval_counter = 0
      end

      if logger
        log = -> s { logger_info(s, player: player, depth: depth) }
      end

      if depth_max <= depth
        @eval_counter += 1
        score = player.evaluator(iparams).score
        log.call("%+d" % score) if log
        return [score, []]
      end

      if true
        children = player.normal_all_hands
      else
        # @hands_memo[depth] ||= player.normal_all_hands.to_a
        # children = @hands_memo[depth]
      end

      best_pv = []
      best_hand = nil
      children_exist = false

      children.each do |hand|
        unless hand.legal_move?(mediator)
          # log.call "skip: #{hand}" if log
          next
        end
        children_exist = true

        log.call "#{hand}" if log

        # 玉が取られても相手の玉を取り返せば形勢は互角になる。
        # そうなるとピンチであることに気づかない。
        # だかから玉を取ったかどうかの判定を入れて玉を取った時点で最大の評価値にして探索を打ち切る

        # 非合法手が混っている場合はこのチェックが重要になってくる
        # if hand.king_captured?
        #   raise
        #   # alpha = INF_MAX - depth
        #   # best_hand = hand
        #   # best_pv = [best_hand]
        #   return [INF_MAX, [hand]]
        # else
        v = nil
        pv = nil
        hand.sandbox_execute(mediator) do
          v, pv = dive(player.opponent_player, depth + 1, -beta, -alpha)
          v = -v
        end
        # p [alpha, v]
        if alpha < v
          alpha = v
          best_hand = hand
          best_pv = [hand, *pv]
          # best_pv = foo + [hand]
        end
        if alpha >= beta
          break
          # end
        end
      end

      if true
        unless children_exist
          # 手が一つも生成できなかった場合は詰んでいる
          alpha = -score_max_for(depth)
          best_pv = ["(詰み)"] # 注意。-INF_MAX を返すと alpha < v が成立しないため読み筋が返せない。
        end
      end

      # unless children_exist
      #   raise BioshogiError, "#{player.call_name}の指し手が一つもありません。すべての駒を取られている可能性があります\n#{mediator.to_bod}"
      # end

      if best_hand
        log.call "★確 #{best_hand} (#{alpha})" if log
      end

      # p [alpha, best_pv]
      [alpha, best_pv]
    end
  end

  class NegaScoutDiver < Diver
    def dive(player = iparams[:current_player], depth = 0, alpha = -INF_MAX, beta = INF_MAX)
      out_of_time_check

      mediator = player.mediator

      if depth == 0
        @eval_counter = 0
      end

      if logger
        log = -> s { logger_info(s, player: player, depth: depth) }
      end

      if depth_max <= depth
        @eval_counter += 1
        score = player.evaluator(iparams).score
        log.call("%+d" % score) if log
        return [score, []]
      end

      children = player.normal_all_hands

      # log.call "指し手 #{children.to_a}" if log

      # # 合法手がない場合はパスして相手に手番を渡す
      # if children.empty?
      #   v, pv = dive(player.opponent_player, depth + 1, -beta, -alpha)
      #   v = -v
      #   return [v, [:pass, *pv]]
      # end

      # mate_check = Proc.new { |hand|
      #   # if hand.king_captured?
      #   #   return [INF_MAX, [hand]]
      #   # end
      # }

      # 再帰を簡潔に記述するため
      recursive = Proc.new { |hand, alpha2, beta2|
        # # 玉が取られても相手の玉を取り返せば形勢は互角になる。
        # # そうなるとピンチであることに気づかない。
        # # だかから玉を取ったかどうかの判定を入れて玉を取った時点で最大の評価値にして探索を打ち切る
        if hand.king_captured?
          raise
          # v = INF_MAX - depth
          v = INF_MAX
          log.call "#{hand} -> #{v} #{player.location}勝" if log
          return [v, [hand]]
        else
          log.call "#{hand}" if log
          hand.sandbox_execute(mediator) do
            v, pv = dive(player.opponent_player, depth + 1, alpha2, beta2)
            v = -v
            [v, pv]
            # end
          end
        end
      }

      # children が空の場合を考慮して初期値を投了級にしておく
      max_v = -score_max_for(depth) # 浅いほど評価値を高くして最短で詰ますようにする
      # max_v = -INF_MAX # 浅いほど評価値を高くして最短で詰ますようにする
      best_pv = ["(詰み)"]      # 一度も更新されなかったら手がないということなので詰んでいる

      if true
        # 効果的なもの順に並び換える→どうやって？？？
        # children = mediator.move_ordering(player, children)
        children = children.to_a # FIXME: 並び返るために全取得すると遅延評価にした意味がない

        # 最善候補を通常の窓で探索

        # ベストな「合法手」を取得
        hand = nil
        loop do
          hand = children.shift # FIXME: 配列として扱わなければ速くなるかも
          if hand.nil?
            break
          end
          if hand.legal_move?(mediator)
            break
          end
        end

        if hand
          # mate_check.call(hand)

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
        unless hand.legal_move?(mediator)
          next
        end

        # mate_check.call(hand)
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
        if max_v < v
          max_v = v
          best_pv = [hand, *pv]
        end
      end

      log.call "★確 #{best_pv.first || '?'}" if log
      [max_v, best_pv]
    end
  end
end
