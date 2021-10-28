require "./setup"

usi = SfenFacade::SetupFromSource.new
usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
usi.mediator.to_history_sfen    # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
usi.execute("position startpos moves 7i6h")
usi.mediator.to_history_sfen    # => "position startpos moves 7i6h"
usi.execute("position startpos")
usi.mediator.to_history_sfen            # => "position startpos"
usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
usi.mediator.to_history_sfen # => "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
usi.execute("position startpos")
usi.mediator.to_snapshot_sfen # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
