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

  data = {
    :pieces => {:black => "桂2"},
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

  p BaseFormat::Parser.board_parse(data[:board])
  p Utils.pieces_parse(data[:pieces][:black])
  p Utils.pieces_parse(data[:pieces][:white])

  frame = LiveFrame.new
  frame.player_join(Player.new(:location => :black))
  frame.player_join(Player.new(:location => :white))

  board_info = BaseFormat::Parser.board_parse(data[:board])
  frame.players[Location[:white].index].initial_put_on(board_info[:white][:soldiers], :from_piece => false)
  frame.players[Location[:black].index].initial_put_on(board_info[:black][:soldiers], :from_piece => false)

  
  
  puts frame
end
