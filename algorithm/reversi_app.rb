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

  def available_places(player)
    blank_places.find_all { |e| can_place_on?(player, e) }
  end

  def place_on(player, place, &block)
    if block_given?
      memento = board.dup
      begin
        place_on(player, place)
        yield
      ensure
        self.board = memento
      end
    else
      hash = reversible_counts_hash(player, place)

      # 空なら利きが一つもないことになるのでパスになるが事前にチェックしておきたいのでここでは例外とする
      if hash.empty?
        raise "反転できないのに置きました : player:#{player} place:#{place}\n#{self}"
      end

      # 置く
      board[place] = player
      # run_counts[:place_on] += 1

      # 反転していく
      hash.each do |vec, count|
        v = place
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
      places = available_places(player)
      count = nil
      if places.empty?
        @pass_count += 1
      else
        @pass_count = 0
        if true
          # 賢く指す
          place = move_ordering(player, places).first
        else
          # 適当に指す
          place = places.sample
        end
        count = place_on(player, place)
      end
      puts "---------------------------------------- [#{turn}] #{player} 反転数:#{count || 'pass'} #{histogram} 評価値:#{evaluate(:o)}"
      puts self
    end
    tp board.values.group_by(&:itself).transform_values(&:size)
  end

  def move_ordering(player, places)
    places.sort_by { |e| -reversible_total_count(player, e) }
  end

  private

  def reversible_total_count(player, place)
    reversible_counts_hash(player, place).values.sum
  end

  # 1個以上反転させられる利きと個数をペアにしたハッシュを返す
  def reversible_counts_hash(player, place)
    Around.collect { |vec|
      count = reversible_one_way_count(player, place, vec)
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

  def blank_places
    dimension.times.flat_map { |y|
      dimension.times.collect { |x|
        v = Vector[x, y]
        unless board[v]
          v
        end
      }
    }.compact
  end

  def can_place_on?(player, place)
    raise "not blank" if board[place]
    Around.any? { |e| reversible_one_way_count(player, place, e) >= 1 }
  end

  def reversible_one_way_count(player, place, vec)
    count = 0
    loop do
      place += vec          # 置いた次の位置から進めるため最初に実行する
      # 外に出てしまったらダメ
      if place.any? { |e| !(0...dimension).cover?(e) }
        count = 0
        break
      end
      element = board[place]
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
