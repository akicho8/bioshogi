# 駒の情報
require "./example_helper"

tp Piece["飛"].to_h
# >> |----------------+--------------------------------------------|
# >> |            key | rook                                       |
# >> |           name | 飛                                         |
# >> |  promoted_name | 龍                                         |
# >> |    basic_names | ["飛", "HI", "R", :rook]                   |
# >> | promoted_names | ["龍", "竜", "RY"]                         |
# >> |          names | ["飛", "HI", "R", :rook, "龍", "竜", "RY"] |
# >> |     promotable | true                                       |
# >> |----------------+--------------------------------------------|
