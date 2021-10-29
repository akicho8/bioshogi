require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b"
info = Parser.parse(sfen)
bin = info.to_animation_mp4(width: 1920, height: 1080, end_duration: 0, color_theme_key: "is_color_theme_groovy_board_texture1", turn_embed_key: "is_turn_embed_on")
Pathname("_output.mp4").write(bin)
`chrome _output.mp4`
