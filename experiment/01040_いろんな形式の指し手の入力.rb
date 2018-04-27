require "./example_helper"

def f(v)
  mediator = Mediator.new
  mediator.placement_from_preset("平手")
  mediator.execute(v)
  mediator.hand_logs.to_kif_a
end

f "76歩"                        # => ["７六歩(77)"]
f "7776FU"                      # => ["７六歩(77)"]
f "７六歩"                      # => ["７六歩(77)"]
f "76歩"                        # => ["７六歩(77)"]
f "0076FU" rescue $!            # => #<Warabi::DoublePawnCommonError: 【反則】二歩です。すでに▲７七歩があるため▲７六歩打ができません
