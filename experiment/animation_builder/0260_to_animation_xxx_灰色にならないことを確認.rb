require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

[
  :mp4,
  :apng,
  :gif,
  :webp,
].each do |e|
  info = Parser.parse("position startpos moves 7g7f 8c8d")
  bin = info.public_send("to_animation_#{e}", cover_text: "#{e}", color_theme_key: "is_color_theme_real", tmpdir_remove: true)
  Pathname("_output.#{e}").write(bin)
  identify "_output.#{e}"
  chrome "_output.#{e}"
end
