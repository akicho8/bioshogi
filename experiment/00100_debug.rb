require "./example_helper"

# Pathname.glob("囲い/アヒル囲い.*".encode("UTF-8", "UTF8-MAC"))   # => [#<Pathname:囲い/アヒル囲い.kif>]
# 
# Pathname.glob("囲い/ボナンザ囲い.{kif,ki2}") # => [#<Pathname:囲い/ボナンザ囲い.kif>]
# 
# Pathname.glob("囲い/ダイヤモンド美濃.*")   # => []
# Pathname.glob("囲い/ダイヤモンド美濃.kif") # => [#<Pathname:囲い/ダイヤモンド美濃.kif>]

# mediator = Mediator.new
# mediator.placement_from_preset("平手")
# mediator.turn_info.turn_max  # => 0
# mediator.current_player.location  # => <black>
# # mediator.execute("７六歩")
# # mediator.execute("３四歩")
# # mediator.execute("２二角成")
# # mediator.player_at(:black).piece_box.to_s # => "角"
# # puts mediator
# 
# mediator = Mediator.new
# mediator.placement_from_preset("平手")
# mediator.turn_info.turn_max  # => 0
# mediator.current_player.location  # => <black>

mediator = Mediator.new
mediator.placement_from_preset("平手")
mediator.turn_info.turn_max  # => 0
mediator.current_player.location  # => <black>
mediator.execute("７六歩")
mediator.turn_info.turn_max     # => 1
mediator.execute("３四歩")
mediator.turn_info.turn_max     # => 2
mediator.execute("１１角成") rescue $!
mediator.turn_info.turn_max     # => 2
