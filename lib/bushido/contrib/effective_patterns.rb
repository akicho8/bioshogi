# -*- coding: utf-8 -*-

require_relative "../../bushido"

module Bushido
  # params = {
  #   :player => :black,
  # }.merge(params)
  # player = Player.create2(params[:player], Board.new)
  #
  # # 最初にくばるオプション
  # player.deal(params[:deal])
  #
  # player.initial_put_on(params[:init])
  # if params[:piece_plot]
  #   player.piece_plot
  # end
  #
  # Array.wrap(params[:exec]).each{|v|player.execute(v)}
  #
  # # あとでくばる(というかセットする)
  # if params[:pieces]
  #   player.piece_discard
  #   player.deal(params[:pieces])
  # end
  #
  # player

  # end

  record = {
    :title => "桂と金の交換または桂成(おじいちゃんがよく使っていた技)",
    :comment => "金が逃げても３二桂成を防げない",
    :pieces => {:black => "桂"},
    :execute => "▲２四桂 △２三金 ▲３二桂成",
    :board => <<-EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・v銀v金|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
EOT
  }

  # p BaseFormat::Parser.board_parse(record[:board])
  # p Utils.stand_parse(record[:pieces][:black])
  # p Utils.stand_parse(record[:pieces][:white])

  frame = LiveFrame.new
  frame.player_join(Player.new(:location => :black))
  frame.player_join(Player.new(:location => :white))

  board_info = BaseFormat::Parser.board_parse(record[:board])
  frame.players[Location[:white].index].initial_put_on(board_info[:white][:soldiers], :from_piece => false)
  frame.players[Location[:black].index].initial_put_on(board_info[:black][:soldiers], :from_piece => false)

  frame.players[Location[:white].index].deal(record[:pieces][:white])
  frame.players[Location[:black].index].deal(record[:pieces][:black])

  puts frame
  Utils.ki2_input_seq_parse(record[:execute]).each{|hash|
    frame.players[Location[hash[:location]].index].execute(hash[:input])
    puts frame
  }
end
