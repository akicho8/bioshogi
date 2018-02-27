require "matrix"
require "org_tp"

class ReversiApp
  Around = [
    [-1, -1], [0, -1], [1, -1],
    [-1,  0],          [1,  0],
    [-1,  1], [0,  1], [1,  1],
  ].collect { |e| Vector[*e] }

  attr_accessor :board
  attr_accessor :players
  attr_accessor :params
  attr_accessor :pass_count

  def initialize(**params)
    @params = {
      dimension: 4 * 2,
    }.merge(params)

    @players = [:o, :x]
    @board = {}
    @pass_count = 0

    placement
  end

  def available_points(player)
    blank_points.find_all { |e| can_put_on?(player, e) }
  end

  def put_on(player, point, &block)
    if block_given?
      memento = board.dup
      begin
        put_on(player, point)
        yield
      ensure
        self.board = memento
      end
    else
      hash = reversible_counts_hash(player, point)

      # 空なら利きが一つもないことになるのでパスになるが事前にチェックしておきたいのでここでは例外とする
      if hash.empty?
        raise "反転できないのに置きました : player:#{player} point:#{point}\n#{self}"
      end

      # 置く
      board[point] = player
      # run_counts[:put_on] += 1

      # 反転していく
      hash.each do |vec, count|
        v = point
        count.times do
          v += vec
          board[v] = player
        end
      end
    end
  end

  def evaluate(player)
    run_counts[:evaluate] += 1
    hash = histogram
    same_pos[board] += 1
    o = hash[:o]
    x = hash[:x]
    if player == :o
      o - x
    else
      x - o
    end
  end

  def histogram
    players.inject({}) { |a, e| a.merge(e => board.values.count(e)) }
  end

  def player_at(turn)
    players[turn.modulo(players.count)]
  end

  def continuous_pass?
    pass_count >= players.size
  end

  def game_over?
    board.size >= (dimension**2) || continuous_pass?
  end

  def run_counts
    @run_counts ||= Hash.new(0)
  end

  def same_pos
    @same_pos ||= Hash.new(0)
  end

  def dimension
    params[:dimension]
  end

  def to_s
    dimension.times.collect { |y|
      dimension.times.collect { |x|
        v = board[Vector[x, y]]
        if v
          if v == :o
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

  def run
    placement
    256.times do |turn|
      if game_over?
        break
      end
      player = player_at(turn)
      points = available_points(player)
      count = nil
      if points.empty?
        @pass_count += 1
      else
        @pass_count = 0
        if true
          # 賢く指す
          point = move_ordering(player, points).first
        else
          # 適当に指す
          point = points.sample
        end
        count = put_on(player, point)
      end
      puts "---------------------------------------- [#{turn}] #{player} 反転数:#{count || 'pass'} #{histogram} 評価値:#{evaluate(:o)}"
      puts self
    end
    tp board.values.group_by(&:itself).transform_values(&:size)
  end

  def move_ordering(player, points)
    points.sort_by { |e| -reversible_total_count(player, e) }
  end

  private

  def reversible_total_count(player, point)
    reversible_counts_hash(player, point).values.sum
  end

  # 1個以上反転させられる利きと個数をペアにしたハッシュを返す
  def reversible_counts_hash(player, point)
    Around.collect { |vec|
      count = reversible_one_way_count(player, point, vec)
      if count >= 1
        [vec, count]
      end
    }.compact.to_h
  end

  def placement
    half = dimension / 2
    board[Vector[half - 1, half - 1]] = :x
    board[Vector[half, half]]         = :x
    board[Vector[half, half - 1]]     = :o
    board[Vector[half - 1, half]]     = :o
  end

  def blank_points
    dimension.times.flat_map { |y|
      dimension.times.collect { |x|
        v = Vector[x, y]
        unless board[v]
          v
        end
      }
    }.compact
  end

  def can_put_on?(player, point)
    raise "not blank" if board[point]
    Around.any? { |e| reversible_one_way_count(player, point, e) >= 1 }
  end

  def reversible_one_way_count(player, point, vec)
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
end

if $0 == __FILE__
  ReversiApp.new.run
end
# ~> -:134:in `block in run': undefined local variable or method `pass_reset' for #<ReversiApp:0x00007feb7e156050> (NameError)
# ~> Did you mean?  pass_count
# ~> 	from -:124:in `times'
# ~> 	from -:124:in `run'
# ~> 	from -:220:in `<main>'
