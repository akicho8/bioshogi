require "../example_helper"

Mediator.facade(init: "", execute: ["55飛"]) rescue $!   # => #<Bioshogi::HoldPieceNotFound2: ５五に移動できる飛がないため打の省略形と考えましたが飛を持っていません
Mediator.facade(init: "", execute: ["55飛打"]) rescue $! # => #<Bioshogi::HoldPieceNotFound: 打を明示しましたが飛を持っていません
