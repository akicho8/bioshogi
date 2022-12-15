require "../setup"

Parser.parse("P+00HI").xcontainer.player_at(:black).piece_box.to_s # => "飛"
Parser.parse("P+00HI00HI").xcontainer.player_at(:black).piece_box.to_s # => "飛二"

info = Parser.parse("PI\nP1") rescue $!     # => * @mi.board_source
info = Parser.parse("PI\nP+59OU") rescue $! # => * @mi.board_source
info = Parser.parse("P1\nP+59OU") rescue $! # => #<Bioshogi::SyntaxDefact: P+59OU としましたがすでに、PI か P1 表記で盤面の指定があります。無駄にややこしくなるので PI P1 P+59OU 表記を同時に使わないでください>

puts Parser.parse("PI\nP+00HI").to_csa
puts Parser.parse("P1\nP+00HI").to_csa

# >> V2.2
# >> P1 *  *  *  *  *  *  *  *  * 
# >> P2 *  *  *  *  *  *  *  *  * 
# >> P3 *  *  *  *  *  *  *  *  * 
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7 *  *  *  *  *  *  *  *  * 
# >> P8 *  *  *  *  *  *  *  *  * 
# >> P9 *  *  *  *  *  *  *  *  * 
# >> P+00HI
# >> +
# >> %TORYO
# >> 
# >> V2.2
# >> P1 *  *  *  *  *  *  *  *  * 
# >> P2 *  *  *  *  *  *  *  *  * 
# >> P3 *  *  *  *  *  *  *  *  * 
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7 *  *  *  *  *  *  *  *  * 
# >> P8 *  *  *  *  *  *  *  *  * 
# >> P9 *  *  *  *  *  *  *  *  * 
# >> P+00HI
# >> +
# >> %TORYO
# >> 
