require "#{__dir__}/setup"

container = Container::Basic.new
container.board.placement_from_shape(<<~EOT)
+---------------------------+
|v香 ・ ・ ・ ・v銀 ・ ・ ・|
| ・ ・ ・v金v金v玉 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ 歩 ・ 歩 ・ ・ ・ ・|
| ・ ・ ・ 歩 ・ ・ ・ ・ ・|
| ・ ・ 金 銀 金 ・ ・ ・ ・|
| 香 ・ ・ 玉 ・ ・ ・ ・ ・|
+---------------------------+
  EOT

location = Location[:black]

soldiers = container.board.surface.values.find_all { |e|e.location == location }
tp soldiers.collect(&:name)
sorted_black_side_soldiers = soldiers.collect { |e|e.white_then_flip }.sort
tp sorted_black_side_soldiers

defense_info = Analysis::DefenseInfo.find do |e|
  # p e.name

  # 盤上の状態に含まれる？
  e.black_side_soldiers.all? do |e|
    if soldier = container.board[e[:place]]
      if soldier.location == location
        soldier.white_then_flip == e
      end
    end
  end

  # # 盤上と完全一致
  # e.sorted_black_side_soldiers == sorted_black_side_soldiers
end
tp defense_info
# ~> -:29:in `block in <main>': undefined method `black_side_soldiers' for #<Bioshogi::DefenseInfo:0x00007f82a51bec00> (NoMethodError)
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/memory_record-0.0.9/lib/memory_record/memory_record.rb:147:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/memory_record-0.0.9/lib/memory_record/memory_record.rb:147:in `each'
# ~> 	from -:25:in `find'
# ~> 	from -:25:in `<main>'
# >> |----------|
# >> | ▲７六歩 |
# >> | ▲５六歩 |
# >> | ▲６七歩 |
# >> | ▲７八金 |
# >> | ▲６八銀 |
# >> | ▲５八金 |
# >> | ▲９九香 |
# >> | ▲６九玉 |
# >> |----------|
# >> |----------|
# >> | ▲９九香 |
# >> | ▲７六歩 |
# >> | ▲７八金 |
# >> | ▲６七歩 |
# >> | ▲６八銀 |
# >> | ▲６九玉 |
# >> | ▲５六歩 |
# >> | ▲５八金 |
# >> |----------|
