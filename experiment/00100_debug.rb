require "./example_helper"

mediator_options = {
  skill_monitor_enable: false,
  skill_monitor_technique_enable: false,
  candidate_skip: true,
  validate_skip: true,
}

info = Parser.parse("55玉(59)", mediator_options)
puts info.to_kif
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ５五玉(59)   (00:00/00:00:00)
# >>    2 投了
# >> まで1手で先手の勝ち
