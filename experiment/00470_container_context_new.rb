require "./setup"

s = Container::ContainerStack.new
s.context_new do
  s.container.to_short_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
  s.context_new do
    s.container.placement_from_preset("十枚落ち")
    s.container.to_short_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    s.context_new do
      s.container.execute("▲２六歩")
      s.container.to_short_sfen # => "sfen 4k4/9/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w - 2"
    end
    s.container.to_short_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
  end
  s.container.to_short_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
end
