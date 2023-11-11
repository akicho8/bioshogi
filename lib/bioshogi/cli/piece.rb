require "../cli" if $0 == __FILE__

module Bioshogi
  class CLI
    desc "piece", "駒一覧"
    def piece
      tp Piece.collect(&:to_h)
    end
  end
end

if $0 == __FILE__
  Bioshogi::CLI.start(["piece"])
end
# >> |--------+------+-------------+---------------+----------------------------+------------------------------+-----------+------------+--------------+----------+------|
# >> | key    | name | basic_alias | promoted_name | promoted_formal_sheet_name | other_matched_promoted_names | sfen_char | promotable | always_alive | stronger | code |
# >> |--------+------+-------------+---------------+----------------------------+------------------------------+-----------+------------+--------------+----------+------|
# >> | king   | 玉   | 王          |               |                            |                              | K         | false      | true         | false    |    0 |
# >> | rook   | 飛   |             | 龍            |                            | 竜                           | R         | true       | true         | true     |    1 |
# >> | bishop | 角   |             | 馬            |                            |                              | B         | true       | true         | true     |    2 |
# >> | gold   | 金   |             |               |                            |                              | G         | false      | true         | false    |    3 |
# >> | silver | 銀   |             | 全            | 成銀                       |                              | S         | true       | true         | false    |    4 |
# >> | knight | 桂   |             | 圭            | 成桂                       | 今                           | N         | true       | false        | false    |    5 |
# >> | lance  | 香   |             | 杏            | 成香                       | 仝                           | L         | true       | false        | false    |    6 |
# >> | pawn   | 歩   |             | と            |                            |                              | P         | true       | false        | false    |    7 |
# >> |--------+------+-------------+---------------+----------------------------+------------------------------+-----------+------------+--------------+----------+------|
