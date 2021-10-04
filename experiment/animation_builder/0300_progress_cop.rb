require "../example_helper"
info = Parser.parse("position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g")

params = { end_duration: 1, cover_text: "x", progress_callback: -> e { puts e.log } }

info.to_animation_mp4(params)
info.to_animation_gif(params)

info.to_animation_mp4(params.merge(factory_method_key: "rmagick"))
info.to_animation_gif(params.merge(factory_method_key: "rmagick"))

info.to_animation_zip(params)
