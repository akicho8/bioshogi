require "./example_helper"

usi = Usi::Class2.new
usi.execute("one_place sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
usi.mediator.to_sfen    # => "one_place sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
usi.execute("one_place startpos moves 7i6h")
usi.mediator.to_sfen    # => "one_place startpos moves 7i6h"
usi.execute("one_place startpos")
usi.mediator.to_sfen            # => "one_place startpos"
usi.execute("one_place sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
usi.mediator.to_sfen # => "one_place sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
usi.execute("one_place startpos")
usi.mediator.to_long_sfen # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
