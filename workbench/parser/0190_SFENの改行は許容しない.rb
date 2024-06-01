require "../setup"
Sfen.parse("position startpos moves 2g2f\n3c3d").moves # => ["2g2f"]
Sfen.parse("position startpos moves 2g2f\n").moves     # => ["2g2f"]
