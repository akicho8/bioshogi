class OneDementionalReversiApp
  Around = [-1, 1]

  attr_accessor :dimention
  attr_accessor :board, :players

  def initialize
    @dimention = 4 * 2
    @players = ["o", "x"]
    @board = {}
  end

  def placement
    half = dimention / 2
    board[half - 1] = "o"
    board[half] = "x"
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
    Around.inject({}) do |a, vec|
      a.merge(vec => reversible_count(player, point, vec))
    end
  end

  # player が point の位置に置いたと仮定したとき vec の方向で何枚裏返すことができるか
  # 1個以上のときだけその個数を返す
  def reversible_count(player, point, vec)
    count = 0
    loop do
      point += vec          # 置いた次の位置から進めるため最初に実行する
      # 外に出てしまったらダメ
      if !(0...dimention).include?(point)
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
    dimention.times.collect { |i| board[i] || "." }.join
  end

  # 空いている部分の位置をすべて返す
  def blank_points
    dimention.times.find_all { |i| !board[i] }
  end

  def run
    # 中央に4つ置く
    placement
    puts self

    counter = 0                 # 手番カウンター
    turn_limit = 256            # 最大何手まで回すか

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

      counter += 1
      puts "#{to_s} [#{counter}] #{player} 反転数:#{reversed_count || 'skip'} #{board.values.group_by(&:itself).transform_values(&:size)}"
    end

    puts self
    p board.values.group_by(&:itself).transform_values(&:size)
  end
end

if $0 == __FILE__
  ReversiApp.new.run
end
