require "#{__dir__}/setup"

info = Parser.parse("position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2b2g4s4n4l18p 1")
info.to_yomiage # => "gyokugata。ごーいちgyoku。せめかた。ごーさんkin。もちごま。kin。kin"
info = Bioshogi::Parser.parse("position sfen 7g1/8k/7pB/9/9/9/9/9/8L b k2rb3g4s4n3l17p 1")
info.to_yomiage # => "gyokugata。にぃいちkin。いちにぃgyoku。にぃさんhu。せめかた。いちさんkaku。いちきゅうkyo。もちごま。なし"
info = Bioshogi::Parser.parse("position sfen 7gk/7ns/4G4/9/9/9/9/9/9 b 2r2b2g3s3n4l18p 1")
info.to_yomiage # => "gyokugata。いちいちgyoku。にぃいちkin。いちにぃ銀。にぃにぃkeima。せめかた。ごーさんkin。もちごま。なし"
