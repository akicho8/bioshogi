module Bioshogi
  module Diver
    class Base
      attr_accessor :params
      attr_accessor :eval_counter

      # delegate :container, to: :player
      # delegate :evaluate, to: :container
      # delegate :place_on, to: :container
      delegate :logger, :to => "Bioshogi", allow_nil: true

      # iterative_deepening のパラメータがそのまま来ている
      def initialize(params)
        @params = {
          depth_max: 0,         # 深度
          log_take: nil,        # 2 なら最初の2階層までを表示
        }.merge(params)

        @eval_counter = 0
      end

      private

      # ログを減らすには？
      # ・brain.iterative_deepening(log_scope: "▲１二銀打") → 初手「▲１二銀打」から始まるもの
      # ・brain.iterative_deepening(log_scope: "▲１二銀打") → 
      def logger_info_on_depth(str, context)
        return if !logger

        if context[:hand_route]
          if log_scope = params[:log_scope]
            if !context[:hand_route].collect(&:to_s).join(" ").start_with?(log_scope)
              return
            end
          end
        end

        if v = params[:log_take]
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

        logger.info "    %d %s %s" % [
          context[:depth],
          context[:player].location,
          str,
        ]
      end

      def tle_verify
        if t = params[:time_limit_exceeded]
          if t <= Time.now
            throw :time_limit_exceeded
          end
        end
      end

      def depth_max
        params[:depth_max]
      end

      # 深いほど手がかかるので最大の評価値を下げる
      def score_max_of(player, depth)
        # if params[:mate_mode]
        #   return 1
        # end

        v = SCORE_MAX - depth

        # # 詰将棋のときは「持駒を持っているほどスコアを下げる」ことで持駒を使い切った手の方を優先する
        # if params[:mate_mode]
        #   v -= player.op.piece_box.count * 1000
        # end

        v
      end

      # 手を生成
      def collect_children(player, log)
        if params[:mate_mode]
          if params[:base_player].nil?
            raise "mate_mode: true (王手モード) のときは base_player (攻め手のプレイヤー) を指定してください"
          end
          if params[:base_player] == player
            # 詰将棋モードなら自分だけ王手のみを生成する
            v = player.create_all_hands(legal_only: true, mate_only: true).entries
            log["王手のみの手を生成: #{v.collect(&:to_s).join(', ')}"] if log
            v
          else
            # 王手を外す手だけを生成する
            v = player.create_all_hands(legal_only: true).entries
            log["王手解除の手を生成: #{v.collect(&:to_s).join(', ')}"] if log
            v
          end
        else
          player.create_all_hands(promoted_only: true).entries
        end
      end
    end
  end
end
