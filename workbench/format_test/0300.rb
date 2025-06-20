require "../setup"
info = Parser.parse(<<~EOT, typical_error_case: :embed)
手合割：平手
手数----指手---------消費時間--
   1 ２六歩(27)
   2 ８八角成(22)
   3 ８八銀(79)
EOT
# p info
puts info.to_csa






























