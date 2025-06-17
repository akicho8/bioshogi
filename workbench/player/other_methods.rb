require "#{__dir__}/setup"
container = Container::Basic.new
container.board.placement_from_human("△51玉 △22角 ▲28飛")
container.player_at(:black).zengoma? # => nil
container.execute("▲22飛成")
container.player_at(:black).zengoma? # => true
