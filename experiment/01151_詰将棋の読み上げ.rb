require "./example_helper"

info = Parser.parse("position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2b2g4s4n4l18p 1")
info.to_yomiage # => "gyokugata。ごーいちぎょく。せめかた。ごーさんきん。もちごま。きん。きん。"
