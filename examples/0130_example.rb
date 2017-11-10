# 駒の情報
require "./example_helper"

pp Piece["飛"].to_h
# >> {:name=>"飛",
# >>  :promoted_name=>"龍",
# >>  :basic_names=>["飛", "rook"],
# >>  :promoted_names=>["龍", "ROOK", "竜"],
# >>  :names=>["飛", "rook", "龍", "ROOK", "竜"],
# >>  :key=>:rook,
# >>  :promotable?=>true,
# >>  :basic_once_vectors=>[],
# >>  :basic_repeat_vectors=>[nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil],
# >>  :promoted_once_vectors=>
# >>   [[-1, -1], nil, [1, -1], nil, nil, nil, [-1, 1], nil, [1, 1]],
# >>  :promoted_repeat_vectors=>
# >>   [nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil]}
