require "../example_helper"
sfen = "position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g"
info = Parser.parse(sfen)

params = { end_duration_sec: 1, cover_text: "x", progress_callback: -> e { puts e.log } }

info.to_mp4(params)
info.to_animation_gif(params)

info.to_mp4(params.merge(media_factory_key: "rmagick"))
info.to_animation_gif(params.merge(media_factory_key: "rmagick"))

info.to_animation_zip(params)
