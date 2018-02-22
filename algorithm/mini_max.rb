require "./reversi_app"

class MiniMax
  attr_accessor :app, :choice

  def run
    @app = ReversiApp.new(dimension: 6)

    # turn = 0
    # @choice = nil
    # p mini_max(turn, 5)
    # p @choice

    3.times do |turn|
      p turn
      @choice = nil
      mini_max(turn, 2)
      player = app.player_at(turn)
      
      # 不具合
      puts app
      app.reverse_cells(player, @choice)
      puts app
      exit
      
      puts "-------------------- #{turn}: #{player} #{@choice.to_a}"
      puts app
    end
  end

  def mini_max(turn, depth)
    player = app.player_at(turn)

    if depth == 0
      return app.evaluate0
    end

    if turn.even?
      # 自分が自分にとってもっとも有利な手を探す
      max = -Float::INFINITY
      app.available_points(player).each do |vec|
        save = app.board.dup
        app.reverse_cells(player, vec)
        score = mini_max(turn + 1, depth - 1)
        app.board = save
        if score > max
          @choice = vec
          max = score
        end
      end
      max
    else
      # 相手が自分にとってもっとも不利な手を探す
      min = Float::INFINITY
      app.available_points(player).each do |vec|
        save = app.board.dup
        app.reverse_cells(player, vec)
        score = mini_max(turn + 1, depth - 1)
        app.board = save
        if score < min
          @choice = vec
          min = score
        end
      end
      min
    end
  end
end

MiniMax.new.run
# >> 3
# >> Vector[4, 2]
