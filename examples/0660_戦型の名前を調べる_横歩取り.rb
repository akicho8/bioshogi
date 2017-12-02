require "./example_helper"

# AttackInfo["新米長玉"].self_check # => 
# AttackInfo["横歩取り"].self_check # => 

DefenseInfo["端玉銀冠"].self_check # => ["舟囲い", "天守閣美濃", "端玉銀冠"]

info = Parser.parse(<<~EOT)
EOT
puts info.to_ki2                     # => nil
# >> 先手の囲い：
# >> 後手の囲い：
# >> 先手の戦型：
# >> 後手の戦型：
# >> 手合割：平手
# >> 
# >> まで0手で後手の勝ち
