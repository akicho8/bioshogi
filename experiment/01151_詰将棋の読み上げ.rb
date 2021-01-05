require "./example_helper"

info = Parser.parse("position sfen 3skg3/R8/9/9/9/9/9/9/9 b 2R2B3g3s4n4l18p 1")
info.to_yomiage        # => "gyokugata。きゅうにぃひしゃ。せめかた。ごーいちぎょく。よんいちきん。ろくいちぎん。もちごま。ひしゃ。ひしゃ。かく。かく。"
