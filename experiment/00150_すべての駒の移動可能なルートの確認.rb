# すべての駒の移動可能なルートの確認
require "./example_helper"

Piece.each do |piece|
  mediator = Mediator.new
  player = mediator.player_at(:black)
  player.battlers_create("５五#{piece.name}", from_stand: false)
  player.board["５五"].movable_infos.each do |v|
    player.board.abone_on(v.point)
    s = "#{v.point}竜"
    player.battlers_create(s, from_stand: false)
  end
  puts mediator.board
end
# ~> /Users/ikeda/src/warabi/lib/warabi/board.rb:21:in `put_on': undefined local variable or method `point' for #<Warabi::Board:0x00007f9a9d0f3c98 @surface={}> (NameError)
# ~> Did you mean?  print
# ~>                printf
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:348:in `put_on_with_valid'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:254:in `battlers_create_from_soldier'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:73:in `block in battlers_create'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:61:in `each'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:61:in `battlers_create'
# ~> 	from -:7:in `block in <main>'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/memory_record-0.0.9/lib/memory_record/memory_record.rb:147:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/memory_record-0.0.9/lib/memory_record/memory_record.rb:147:in `each'
# ~> 	from -:4:in `<main>'
