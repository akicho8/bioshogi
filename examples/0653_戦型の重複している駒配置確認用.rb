require "./example_helper"

# rcodetools で実行するとなぜかフリーズする

tp AttackInfo.collect { |e|
  list = AttackInfo.to_a - [e]
  list = list.find_all { |o|
    soldiers = o.sorted_soldiers
    (o.sorted_soldiers& e.sorted_soldiers) == e.sorted_soldiers
  }
  {
    "名前"                 => e.name,
    "形状を含む発展系"     => list.collect(&:name).join(" "),
  }
}
