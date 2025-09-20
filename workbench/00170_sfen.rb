require "#{__dir__}/setup"

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

sfen = Sfen.parse("l2+R1g1nl/4g1ks1/2p1pp1p1/pp4S2/8P/P1P5n/4PPPPN/4GKSs1/L+r3Gb2 b BN2Plp 1")
sfen # => #<Bioshogi::Sfen:0x00007fe7a0130da0 @source="l2+R1g1nl/4g1ks1/2p1pp1p1/pp4S2/8P/P1P5n/4PPPPN/4GKSs1/L+r3Gb2 b BN2Plp 1", @attributes={:board=>"l2+R1g1nl/4g1ks1/2p1pp1p1/pp4S2/8P/P1P5n/4PPPPN/4GKSs1/L+r3Gb2", :b_or_w=>"b", :hold_pieces=>"BN2Plp", :turn_counter_next=>"1", :moves=>nil}>

sfen = Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
sfen.attributes                 # => {:board=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL", :b_or_w=>"b", :hold_pieces=>"S2s", :turn_counter_next=>"1", :moves=>"7i6h S*2d"}
sfen.to_h # => {:soldiers=>[<Bioshogi::Soldier "△９一香">, <Bioshogi::Soldier "△８一桂">, <Bioshogi::Soldier "△７一銀">, <Bioshogi::Soldier "△６一金">, <Bioshogi::Soldier "△５一玉">, <Bioshogi::Soldier "△４一金">, <Bioshogi::Soldier "△３一銀">, <Bioshogi::Soldier "△２一桂">, <Bioshogi::Soldier "△１一香">, <Bioshogi::Soldier "△８二飛">, <Bioshogi::Soldier "△２二角">, <Bioshogi::Soldier "△９三歩">, <Bioshogi::Soldier "△８三歩">, <Bioshogi::Soldier "△７三歩">, <Bioshogi::Soldier "△６三歩">, <Bioshogi::Soldier "△５三歩">, <Bioshogi::Soldier "△４三歩">, <Bioshogi::Soldier "△３三歩">, <Bioshogi::Soldier "△２三歩">, <Bioshogi::Soldier "△１三歩">, <Bioshogi::Soldier "▲９七歩">, <Bioshogi::Soldier "▲８七歩">, <Bioshogi::Soldier "▲７七歩">, <Bioshogi::Soldier "▲６七歩">, <Bioshogi::Soldier "▲５七歩">, <Bioshogi::Soldier "▲４七歩">, <Bioshogi::Soldier "▲３七歩">, <Bioshogi::Soldier "▲２七歩">, <Bioshogi::Soldier "▲１七歩">, <Bioshogi::Soldier "▲８八角">, <Bioshogi::Soldier "▲２八飛">, <Bioshogi::Soldier "▲９九香">, <Bioshogi::Soldier "▲８九桂">, <Bioshogi::Soldier "▲７九銀">, <Bioshogi::Soldier "▲６九金">, <Bioshogi::Soldier "▲５九玉">, <Bioshogi::Soldier "▲４九金">, <Bioshogi::Soldier "▲３九銀">, <Bioshogi::Soldier "▲２九桂">, <Bioshogi::Soldier "▲１九香">], :piece_counts=>{:black=>{:silver=>1}, :white=>{:silver=>2}}, :location=><black>, :moves=>["7i6h", "S*2d"]}

Sfen.startpos_remove("position startpos") # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
Sfen.startpos_embed("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1") # => "position startpos"
