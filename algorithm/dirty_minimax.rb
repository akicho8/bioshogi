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
      if best_hand.kind_of?(Vector)
        app.put_on(player, best_hand)
        app.pass_reset
      else
        app.pass(player)
      end

      unless params[:silent]
        hands2 = hands.collect { |e|
          if e.kind_of?(Vector)
            e.to_a
          else
            e
          end
        }
        puts "---------------------------------------- [#{turn}] #{player} 評価値:#{score} 読み:#{hands2}".strip
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
    # 一番深い局面に達したらはじめて評価する
    if depth >= depth_max
      return [app.evaluate(:o), []] # 常に「先手から」の評価値
    end

    # 合法手がない場合はパスして相手に手番を渡す
    player = app.player_at(turn)
    children = app.can_put_points(player)

    if children.empty?
      score, before = mini_max(turn + 1, depth + 1, depth_max)
      return [score, [:pass, *before]]
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
# >> ---------------------------------------- [0] o 評価値:3 読み:[[1, 0], [0, 0], [0, 1]]
# >> ・○・・
# >> ・○○・
# >> ・○×・
# >> ・・・・
# >> ---------------------------------------- [1] x 評価値:0 読み:[[0, 0], [3, 2], [2, 0]]
# >> ×○・・
# >> ・×○・
# >> ・○×・
# >> ・・・・
# >> ---------------------------------------- [2] o 評価値:3 読み:[[3, 2], [2, 0], [0, 1]]
# >> ×○・・
# >> ・×○・
# >> ・○○○
# >> ・・・・
# >> ---------------------------------------- [3] x 評価値:-2 読み:[[2, 0], [0, 1], [0, 2]]
# >> ×××・
# >> ・×○・
# >> ・○○○
# >> ・・・・
# >> ---------------------------------------- [4] o 評価値:-2 読み:[[0, 1], [0, 2], :pass]
# >> ×××・
# >> ○○○・
# >> ・○○○
# >> ・・・・
# >> ---------------------------------------- [5] x 評価値:-9 読み:[[0, 2], :pass, [2, 3]]
# >> ×××・
# >> ××○・
# >> ×○○○
# >> ・・・・
# >> ---------------------------------------- [6] o 評価値:-9 読み:[:pass, [2, 3], :pass]
# >> ×××・
# >> ××○・
# >> ×○○○
# >> ・・・・
# >> ---------------------------------------- [7] x 評価値:-9 読み:[[1, 3], [0, 3], [2, 3]]
# >> ×××・
# >> ××○・
# >> ××○○
# >> ・×・・
# >> ---------------------------------------- [8] o 評価値:-4 読み:[[0, 3], [2, 3], [3, 0]]
# >> ×××・
# >> ××○・
# >> ×○○○
# >> ○×・・
# >> ---------------------------------------- [9] x 評価値:-5 読み:[[3, 1], [3, 0], [2, 3]]
# >> ×××・
# >> ××××
# >> ×○×○
# >> ○×・・
# >> ---------------------------------------- [10] o 評価値:0 読み:[[3, 0], [2, 3], [3, 3]]
# >> ×××○
# >> ××○○
# >> ×○×○
# >> ○×・・
# >> ---------------------------------------- [11] x 評価値:0 読み:[[2, 3], [3, 3], :pass]
# >> ×××○
# >> ××○○
# >> ×××○
# >> ○××・
# >> ---------------------------------------- [12] o 評価値:0 読み:[[3, 3], :pass, :pass]
# >> ×××○
# >> ××○○
# >> ×××○
# >> ○○○○
# >> |---+---|
# >> | o | 8 |
# >> | x | 8 |
# >> |---+---|
