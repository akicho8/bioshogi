require "./example_helper"

info = Parser.parse("position sfen 3skg3/9/9/9/9/9/9/9/9 b 2R2B3g3s4n4l18p 1")
soldiers = info.mediator.board.soldiers
group = soldiers.group_by{|e|e.location.key} # => {:white=>[<Bioshogi::Soldier "△６一銀">, <Bioshogi::Soldier "△５一玉">, <Bioshogi::Soldier "△４一金">]}
if group[:white]
  group[:white].each do |e|
    e.place.yomiage             # => " 6  1 ", "ごー 1 ", " 4  1 "
    e.yomiage                   # => "ぎん", "ぎょく", "きん"
  end

end


black = info.mediator.player_at(:black)
tp black.piece_box.collect { |piece_key, count|  [Piece.fetch(piece_key), count] }
# >> |-------------------------------------------------|
# >> | [<Bioshogi::Piece:70179604638720 飛 rook>, 2]   |
# >> | [<Bioshogi::Piece:70179604638660 角 bishop>, 2] |
# >> |-------------------------------------------------|
