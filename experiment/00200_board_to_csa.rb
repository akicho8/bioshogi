require "./example_helper"

board = Board.new
board.placement_from_preset("二枚落ち")
puts board.to_csa

puts PresetInfo["二枚落ち"].to_board.to_csa

# >> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
# >> P2 *  *  *  *  *  *  *  *  * 
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI * 
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# >> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
# >> P2 *  *  *  *  *  *  *  *  * 
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI * 
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
