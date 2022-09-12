require "./setup"

s = XcontainerStack.new
s.context_new do
  s.xcontainer.to_short_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
  s.context_new do
    s.xcontainer.placement_from_preset("十枚落ち")
    s.xcontainer.to_short_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    s.context_new do
      s.xcontainer.execute("▲２六歩")
      s.xcontainer.to_short_sfen # => "sfen 4k4/9/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w - 2"
    end
    s.xcontainer.to_short_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
  end
  s.xcontainer.to_short_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
end
