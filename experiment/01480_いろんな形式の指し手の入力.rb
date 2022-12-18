require "./setup"

def f(v)
  container = Container.create
  container.placement_from_preset("平手")
  container.execute(v)
  container.hand_logs.to_kif_a
end

f "76歩"                        # => ["７六歩(77)"]
f "7776FU"                      # => ["７六歩(77)"]
f "７六歩"                      # => ["７六歩(77)"]
f "76歩"                        # => ["７六歩(77)"]
f "0076FU" rescue $!            # => #<Bioshogi::DoublePawnCommonError: 【反則】二歩です。すでに▲７七歩があるため▲７六歩打ができません
