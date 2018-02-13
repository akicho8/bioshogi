require "./example_helper"

s = MediatorMemento.new
s.context_new do
  s.mediator.to_current_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
  s.context_new do
    s.mediator.board.set_from_preset_key("十枚落ち")
    s.mediator.to_current_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    s.context_new do
      s.mediator.execute("▲２六歩")
      s.mediator.to_current_sfen # => "sfen 4k4/9/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w - 2"
    end
    s.mediator.to_current_sfen   # => "sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
  end
  s.mediator.to_current_sfen     # => "sfen 9/9/9/9/9/9/9/9/9 b - 1"
end
