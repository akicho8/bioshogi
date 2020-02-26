require "./example_helper"

sfen = Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
sfen.soldiers.first(3).collect(&:name) # => ["△９一香", "△８一桂", "△７一銀"]
sfen.location.key                      # => :black
sfen.move_infos                        # => [{:input=>"7i6h"}, {:input=>"S*2d"}]
sfen.piece_counts                      # => {:black=>{:silver=>1}, :white=>{:silver=>2}}
sfen.turn_base                      # => 0
sfen.handicap?                         # => false
sfen.attributes                        # => {:board=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", :b_or_w=>"b", :hold_pieces=>"S2s", :turn_counter_next=>"1", :moves=>"7i6h S*2d"}

sfen = Sfen.parse("position startpos")
sfen.attributes # => {:board=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", :b_or_w=>"b", :hold_pieces=>"-", :turn_counter_next=>"1", :moves=>nil}
sfen.soldiers.collect(&:to_s)

sfen = Sfen.parse("position startpos moves 5g5f 8c8d")
sfen.moves # => ["5g5f", "8c8d"]
sfen.board_and_b_or_w_and_piece_box_and_turn # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
sfen.kento_app_url # => "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=5g5f.8c8d"
