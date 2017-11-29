require "./example_helper"

location = Location[:white]

both_board_info = BoardParser.parse(<<~EOT)
+---------------------------+
| ・ ・ ・ ・ ・ ・v銀 ・ ・|
| ・ ・ ・ ・ ・ ・v金v角 ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ 角 金 ・ ・ ・ ・ ・ ・|
| ・ ・ 銀 ・ 玉 金 銀 ・ ・|
+---------------------------+
EOT
info = Utils.board_point_realize2(location: location, both_board_info: both_board_info)

info[Location[:black]].collect(&:name) # => 
info[Location[:white]].collect(&:name) # => 

mediator = Mediator.new
mediator.board_reset_by_shape(<<~EOT)
+---------------------------+
| ・ ・v銀v金v玉 ・v銀 ・ ・|
| ・ ・ ・ ・ ・ ・v金v角 ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・v飛 ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ 角 金 ・ ・ ・ ・ ・ ・|
| ・ ・ 銀 ・ ・ ・ ・ ・ ・|
+---------------------------+
EOT

flag = info.all? do |location, mini_soldiers|
  mini_soldiers.all? do |e|
    if soldier = mediator.board[e[:point]]
      if soldier.player.location == location
        p e == soldier.to_mini_soldier
      end
    end
  end
end

flag                            # => 
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- ./example_helper (LoadError)
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
# ~> 	from -:1:in `<main>'
