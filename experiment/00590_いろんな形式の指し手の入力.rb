require "./example_helper"

def f(v)
  mediator = Mediator.new
  mediator.board_reset
  mediator.execute(v)
  mediator.hand_logs.collect(&:to_s_kif).join(" ")
end

f "76歩"                        # => "７六歩(77)"
f "7776FU"                      # => "７六歩(77)"
f "７六歩"                      # => "７六歩(77)"
f "76歩"                        # => "７六歩(77)"
f "0076FU" rescue $!            # => #<Warabi::HoldPieceNotFound: 持駒に "歩" がありません
