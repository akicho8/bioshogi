require "./example_helper"

mediator = Mediator.new
mediator.board_reset("平手")
puts mediator.board.to_csa
# >> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
# >> P2 * -HI *  *  *  *  * -KA * 
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI * 
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
