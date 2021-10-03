require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

[
  :apng,
  :gif,
  :webp,
].each do |e|
  info = Parser.parse("position startpos moves 7g7f 8c8d")
  bin = info.public_send("to_animation_#{e}", cover_text: "#{e}", color_theme_key: "color_theme_is_real_wood1", tmpdir_remove: true)
  Pathname("_output.#{e}").write(bin)
  identify "_output.#{e}"
  chrome "_output.#{e}"
end
