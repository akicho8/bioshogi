require "./setup"

mediator = Mediator.new
mediator.placement_from_preset("平手")
mediator.before_run_process
mediator.to_history_sfen(startpos_embed: true) # => "position startpos"
mediator.to_history_sfen                       # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
mediator.to_short_sfen                      # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

