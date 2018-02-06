require "./example_helper"

info = Parser.parse(<<~EOT)
V2.2
PI82HI22KA11OU
-
-3334FU
%TORYO
EOT

# ~> /Users/ikeda/src/warabi/lib/warabi/parser/csa_parser.rb:78:in `block in parse': １一の玉を落とす指定がありましたがそこにある駒は香です : "82HI22KA11OU" (Warabi::SyntaxDefact)
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/csa_parser.rb:73:in `scan'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/csa_parser.rb:73:in `parse'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:21:in `tap'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser/base.rb:21:in `parse'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/parser.rb:20:in `parse'
# ~> 	from -:3:in `<main>'
