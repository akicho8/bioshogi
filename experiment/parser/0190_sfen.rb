require "../setup"

Parser.parse("position startpos moves 2g2f\n3c3d").to_sfen # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
Parser.parse("position startpos moves 2g2f\n").to_sfen     # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL x - 1 moves 2g2f\n3c3d")
info.to_sfen                    # => 
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/sfen.rb:48:in `parse': 入力されたSFEN形式が不正確です。原因とは関係ないかもしれないけど途中で改行を含めないでください。 : "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL x - 1 moves 2g2f\n3c3d" (Bioshogi::SyntaxDefact)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/sfen.rb:19:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/sfen.rb:19:in `parse'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser/sfen_parser.rb:14:in `parse'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser/base.rb:15:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser/base.rb:15:in `parse'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:26:in `parse'
# ~> 	from -:5:in `<main>'
