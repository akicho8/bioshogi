require "../setup"

Mediator.facade(init: "", execute: ["55飛"]) rescue $!   # => #<Bioshogi::HoldPieceNotFound2: ５五に移動できる飛がないため打の省略形と考えましたが飛を持っていません。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました
Mediator.facade(init: "", execute: ["55飛打"]) rescue $! # => #<Bioshogi::HoldPieceNotFound: 打を明示しましたが飛を持っていません
Mediator.start.execute("34歩(33)") rescue $!             # => #<Bioshogi::ReversePlayerPieceMoveError: 【反則】相手の駒を動かそうとしています。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました
