require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_preset("平手")
xcontainer.before_run_process
xcontainer.to_history_sfen(startpos_embed: true) # => "position startpos"
xcontainer.to_history_sfen                       # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
xcontainer.to_short_sfen                      # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

