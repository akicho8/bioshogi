# frozen-string-literal: true

module Bioshogi
  class EvaluatorBase
    attr_reader :player
    attr_reader :params

    delegate :mediator, :board, to: :player

    def self.default_params
      {}
    end

    def initialize(player, **params)
      @player = player
      @params = self.class.default_params.merge(params)
    end

    # 自分基準評価値
    def score
      Bioshogi.run_counts["#{self.class.name}#score"] += 1
      basic_score * player.location.value_sign
    end

    private

    # ▲基準評価値
    def basic_score
      score = 0
      board.surface.each_value do |e|
        score += soldier_score(e) * e.location.value_sign
      end
      mediator.players.each do |e|
        score += e.piece_box.score * e.location.value_sign
      end
      score
    end

    # 自分基準評価値
    def soldier_score(e)
      e.abs_weight
    end

    concerning :DebugMethods do
      def detail_score
        rows = []
        rows += detail_score_for(player)
        rows += detail_score_for(player.opponent_player).collect { |e| e.merge(total: -e[:total]) }
        rows + [{total: rows.collect { |e| e[:total] }.sum }]
      end

      private

      def detail_score_for(player)
        rows = player.soldiers.group_by(&:itself).transform_values(&:size).collect { |soldier, count|
          if soldier.promoted
            weight = soldier.piece.promoted_weight
          else
            weight = soldier.piece.basic_weight
          end
          {piece: soldier, count: count, weight: weight, total: weight * count}
        }
        rows + player.piece_box.detail_score
      end
    end
  end

  concern :AttackPieceWeightMethods do
    private

    def soldier_score_for_attack(e)
      if e.promoted || e.piece.key == :gold || e.piece.key == :silver
        # 相手玉
        king_place = mediator.player_at(e.location.flip).king_place
        if king_place
          sx, sy = e.place.to_xy
          tx, ty = king_place.to_xy
          gx = tx - sx
          gy = ty - sy

          oy = attack_weight.size / 2 # 8
          my = oy - gy                  # 8 - (-2) = 10

          mx = gx.abs             # 左右対象
          s = attack_weight.dig(my, mx)
          if s
            # p ["#{__FILE__}:#{__LINE__}", __method__, e, w, s, [mx, my], king_place]
            s
          end
        end
      end
    end

    # 相手玉近くの自分の金銀の価値
    def attack_weight
      @attack_weight ||= [
        [  50,  50,  50,  50,  50,  50,  50,  50,  50],
        [  50,  50,  50,  50,  50,  50,  50,  50,  50],
        [  50,  50,  50,  50,  50,  50,  50,  50,  50],
        [  54,  53,  51,  51,  50,  50,  50,  50,  50],
        [  70,  66,  62,  55,  53,  50,  50,  50,  50],
        [  90,  85,  80,  68,  68,  60,  53,  50,  50],
        [ 100,  97,  95,  85,  84,  71,  51,  50,  50],
        [ 132, 132, 129, 102,  95,  71,  51,  50,  50],
        [ 180, 145, 137, 115,  91,  75,  57,  50,  50], # 0
        [ 170, 165, 150, 121,  94,  78,  58,  52,  50],
        [ 170, 160, 142, 114,  98,  80,  62,  55,  50],
        [ 140, 130, 110, 100,  95,  75,  54,  50,  50],
        [ 100,  99,  95,  87,  78,  69,  50,  50,  50],
        [  80,  78,  72,  67,  55,  51,  50,  50,  50],
        [  62,  60,  58,  52,  50,  50,  50,  50,  50],
        [  50,  50,  50,  50,  50,  50,  50,  50,  50],
        [  50,  50,  50,  50,  50,  50,  50,  50,  50],
      ]
    end
  end

  class EvaluatorAdvance < EvaluatorBase
    include AttackPieceWeightMethods

    private

    def soldier_score(e)
      w = e.abs_weight

      if !e.promoted
        if t = score_table[:field][e.piece.key]
          x, y = e.normalized_place.to_xy
          w += t[y][x]
        end
        if t = score_table[:advance][e.piece.key]
          s = t[e.bottom_spaces]
          w += s
        end
      end

      w += soldier_score_for_attack(e) || 0

      w
    end

    def score_table
      EvaluatorAdvanceScoreTable
    end
  end
end
