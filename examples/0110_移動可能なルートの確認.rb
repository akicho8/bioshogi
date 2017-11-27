# 移動可能なルートの確認
require "./example_helper"

mediator = Mediator.new
player = mediator.player_at(:black)
player.soldiers_create("５五馬", from_stand: false)
player.soldiers.first.movable_infos.each do |v|
  player.soldiers_create("#{v[:point]}馬", from_stand: false)
end
puts mediator.board
# ~> /Users/ikeda/src/bushido/lib/bushido/point.rb:131:in `+': Bushido::OnceVector can't be coerced into Integer (TypeError)
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/point.rb:131:in `vector_add'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/movabler.rb:80:in `block in alive_piece?'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/set.rb:324:in `each_key'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/set.rb:324:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/movabler.rb:79:in `any?'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/movabler.rb:79:in `alive_piece?'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:365:in `dead_piece?'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:336:in `put_on_with_valid'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:233:in `soldiers_create_from_mini_soldier'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:73:in `block in soldiers_create'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:61:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:61:in `soldiers_create'
# ~> 	from -:6:in `<main>'
