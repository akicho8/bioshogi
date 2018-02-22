require "matrix"

class ReversiApp
  V = Vector

  Around = [
    [-1, -1], [0, -1], [1, -1],
    [-1,  0],          [1,  0],
    [-1,  1], [0,  1], [1,  1],
  ].collect { |e| V[*e] }

  attr_accessor :board
  attr_accessor :players
  attr_accessor :params

  def initialize(**params)
    @params = {
      dimension: 4 * 2,
    }.merge(params)

    @players = ["o", "x"]
    @board = {}

    placement
  end

  def dimension
    params[:dimension]
  end

  def placement
    half = dimension / 2
    board[V[half - 1, half - 1]] = "o"
    board[V[half, half]]         = "o"
    board[V[half, half - 1]]     = "x"
    board[V[half - 1, half]]     = "x"
  end

  def reverse_cells(player, point)
    # 1個以上反転させられる利きと個数をペアにしたハッシュを返す
    hash = reversible_info(player, point)

    # 空なら利きが一つもないことになるのでパス
    if hash.values.sum.zero?
      return
    end

    # 置く
    board[point] = player

    # 反転していく
    hash.each do |vec, count|
      v = point
      count.times do
        v += vec
        board[v] = player
      end
    end

    # 反転させた数
    hash.values.sum
  end

  # 1個以上反転させられる利きと個数をペアにしたハッシュを返す
  def reversible_info(player, point)
    Around.collect { |vec|
      count = reversible_count(player, point, vec)
      if count >= 1
        [vec, count]
      end
    }.compact.to_h
  end

  # player が point の位置に置いたと仮定したとき vec の方向で何枚裏返すことができるか
  # 1個以上のときだけその個数を返す
  def reversible_count(player, point, vec)
    count = 0
    loop do
      point += vec          # 置いた次の位置から進めるため最初に実行する
      # 外に出てしまったらダメ
      if point.any? { |e| !(0...dimension).cover?(e) }
        count = 0
        break
      end
      element = board[point]
      # 空の升ならダメ
      unless element
        count = 0
        break
      end
      # 自分の駒が見つかった
      if element == player
        break
      end
      count += 1
    end
    count
  end

  def to_s
    dimension.times.collect { |y|
      dimension.times.collect { |x|
        v = board[V[x, y]]
        if v
          if v == "o"
            "○"
          else
            "×"
          end
        else
          "・"
        end
      }.join + "\n"
    }.join
  end

  # 空いている部分の位置をすべて返す
  def blank_points
    dimension.times.flat_map { |y|
      dimension.times.collect { |x|
        v = V[x, y]
        unless board[v]
          v
        end
      }
    }.compact
  end

  # 置ける部分をすべて返す
  def available_points(player)
    blank_points.find_all do |v|
      !reversible_info(player, v).empty?
    end
  end

  def evaluate(player)
    histogram = board.values.group_by(&:itself).transform_values(&:size)
    if player == "o"
      (histogram["o"] || 0) - (histogram["x"] || 0)
    else
      (histogram["x"] || 0) - (histogram["o"] || 0)
    end
  end

  def evaluate0
    histogram = board.values.group_by(&:itself).transform_values(&:size)
    (histogram["o"] || 0) - (histogram["x"] || 0)
  end

  def player_at(turn)
    players[turn.modulo(players.count)]
  end

  def run
    # 中央に4つ置く
    placement
    puts self

    turn = 0                 # 手番カウンター
    turn_limit = 2560            # 最大何手まで回すか

    turn_limit.times do |turn|
      player = players[turn.modulo(players.size)]
      if blank_points.empty?
        break
      end

      reversed_count = nil      # 反転した駒数を入れる
      if true
        # 賢く指す
        # 相手の駒をより多く反転させられる位置を取得
        point = blank_points.shuffle.max { |point| reversible_info(player, point).values.sum }
        if point
          # その位置に指す (指せない場合もある)
          if count = reverse_cells(player, point) # ここで reversible_info を再び呼ぶのはちょっと無駄がある
            reversed_count = count
          end
        end
      else
        # ルールを守ってランダムに指す
        blank_points.shuffle.each do |point|
          count = reverse_cells(player, point)
          # 反転した数が返る。正しい手が指せたので手番を渡す
          if count
            reversed_count = count
            break
          end
        end
      end

      turn += 1

      puts "--------------------------------------------------------------------------------"
      puts "TURN #{turn} #{player} 反転数:#{reversed_count || 'skip'} #{board.values.group_by(&:itself).transform_values(&:size)}"
      puts self
    end

    puts self
    p board.values.group_by(&:itself).transform_values(&:size)
  end
end

if $0 == __FILE__
  ReversiApp.new.run
end
