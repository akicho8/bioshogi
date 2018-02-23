# 手を返せるようにした実用版(リファクタリング前)

require "./reversi_app"

class DirtyMinimax
  attr_accessor :app
  attr_accessor :params

  def initialize(**params)
    self.params.update(params)
  end

  def params
    @params ||= {
      depth_max: 3,
      dimension: 4,
    }
  end

  def run
    @app = ReversiApp.new(params)

    256.times do |turn|
      score, hands = mini_max(turn, 0, params[:depth_max])
      best_hand = hands.first
      player = app.player_at(turn)
      if best_hand
        app.put_on(player, best_hand)
        app.pass_reset
      else
        app.pass(player)
      end

      unless params[:silent]
        puts "-------------------- #{turn}: #{player} score:#{score} 読み:#{hands.collect(&:to_a)} #{hands.empty? ? 'PASS' : ''}".strip
        puts app
      end

      if app.continuous_pass?
        unless params[:silent]
          puts "両方ともパスしたので終了 : #{app.pass_counts}"
        end
        break
      end

      if app.game_over?
        break
      end
    end
    unless params[:silent]
      tp app.histogram
    end
  end

  def mini_max(turn, depth, depth_max)
    player = app.player_at(turn)
    children = app.available_points(player)

    if children.empty? || depth >= depth_max
      return [app.evaluate_for_o, []] # 常に先手からの評価値
    end

    if turn.even?
      # 自分が自分にとってもっとも有利な手を探す
      max = -Float::INFINITY
      hands = []

      children.each do |point|
        app.put_on(player, point) do
          score, before = mini_max(turn + 1, depth + 1, depth_max)
          if score > max
            hands = [point, *before]
            max = score
          end
        end
      end

      [max, hands]
    else
      # 相手が自分にとってもっとも不利な手を探す
      min = Float::INFINITY
      hands = []
      children.each do |point|
        app.put_on(player, point) do
          score, before = mini_max(turn + 1, depth + 1, depth_max)
          if score < min
            hands = [point, *before]
            min = score
          end
        end
      end

      [min, hands]
    end
  end
end

if $0 == __FILE__
  DirtyMinimax.new.run
end
# >> -------------------- 0: o score:3 読み:[[2, 0], [3, 0], [3, 1]]
# >> ・・○・
# >> ・○○・
# >> ・×○・
# >> ・・・・
# >> -------------------- 1: x score:0 読み:[[3, 0], [0, 2], [1, 0]]
# >> ・・○×
# >> ・○×・
# >> ・×○・
# >> ・・・・
# >> -------------------- 2: o score:3 読み:[[0, 2], [1, 0], [3, 1]]
# >> ・・○×
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 3: x score:-2 読み:[[1, 0], [3, 1], [3, 2]]
# >> ・×××
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 4: o score:-2 読み:[[3, 1], [3, 2]]
# >> ・×××
# >> ・○○○
# >> ○○○・
# >> ・・・・
# >> -------------------- 5: x score:-4 読み:[[0, 3], [1, 3], [0, 1]]
# >> ・×××
# >> ・○×○
# >> ○×○・
# >> ×・・・
# >> -------------------- 6: o score:-2 読み:[[1, 3], [3, 2]]
# >> ・×××
# >> ・○×○
# >> ○○○・
# >> ×○・・
# >> -------------------- 7: x score:-8 読み:[[0, 1], [0, 0], [3, 2]]
# >> ・×××
# >> ×××○
# >> ×○○・
# >> ×○・・
# >> -------------------- 8: o score:-5 読み:[[0, 0], [3, 2], [3, 3]]
# >> ○×××
# >> ×○×○
# >> ×○○・
# >> ×○・・
# >> -------------------- 9: x score:-10 読み:[[3, 2], [3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×○・・
# >> -------------------- 10: o score:-10 読み:[[3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××○×
# >> ×○・○
# >> -------------------- 11: x score:-10 読み:[[2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×××○
# >> |---+----|
# >> | o | 3  |
# >> | x | 13 |
# >> |---+----|
