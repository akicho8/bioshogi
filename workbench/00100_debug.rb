require "./setup"

container_options = {
  analyzer_enable: false,
  analyzer_technique_enable: false,
  ki2_function: false,
  validate_enable: false,
}

info = Parser.parse("55玉(59)", container_options)
puts info.to_kif
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ５五玉(59)   (00:00/00:00:00)
# >>    2 投了
# >> まで1手で先手の勝ち
