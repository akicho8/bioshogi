require "./example_helper"

mediator = Mediator.new
mediator.placement_from_preset("平手")
mediator.before_run_process
mediator.to_sfen                # => "position startpos"
mediator.to_long_sfen # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

