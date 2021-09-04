require "./example_helper"

body = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
info = Parser.parse(body)
info.preset_info.key            # => :角落ち

# Bioshogi::Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1").preset_info # => <平手>
