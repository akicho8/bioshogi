require "../example_helper"

info = Parser.parse(SFEN1)
object = info.image_renderer({
    :color_theme_key     => "color_theme_is_real_wood1",
    :real_shadow_offset  => -4,  # 影の長さ
    :real_shadow_sigma   => 8.0, # 影の強さ (0:影なし)
    :real_shadow_opacity => 0.4, # 不透明度
  })
object.display
