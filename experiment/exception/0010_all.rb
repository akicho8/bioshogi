require "../setup"

Xcontainer.facade(init: "", execute: ["55飛"]) rescue $!   # => #<Bioshogi::HoldPieceNotFound2: ５五に移動できる飛がないため打の省略形と考えましたが飛を持っていません。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました
Xcontainer.facade(init: "", execute: ["55飛打"]) rescue $! # => #<Bioshogi::HoldPieceNotFound: 打を明示しましたが飛を持っていません
Xcontainer.start.execute("34歩(33)") rescue $!             # => #<Bioshogi::ReversePlayerPieceMoveError: 【反則】相手の駒を動かそうとしています。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました
Xcontainer.start.execute("58金") rescue $!                 # => #<Bioshogi::AmbiguousFormatError: ５八に移動できる駒が2つありますが表記が曖昧なため特定できません。移動元は「６九の金」か「４九の金」のどっちかな？
Xcontainer.start.execute("58金上") rescue $!               # => #<Bioshogi::AmbiguousFormatError: ５八に移動できる駒が2つありますが「上」からは特定できません。移動元は「６九の金」か「４九の金」のどっちかな？
