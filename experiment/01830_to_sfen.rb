require "./setup"

container = Container::Basic.new
container.placement_from_preset("平手")
container.before_run_process
container.to_history_sfen(startpos_embed: true) # => "position startpos"
container.to_history_sfen                       # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
container.to_short_sfen                      # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

