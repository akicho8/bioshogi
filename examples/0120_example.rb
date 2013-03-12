# -*- coding: utf-8 -*-
# 駒の情報

require_relative "example_helper"

pp Piece["飛"].to_h
# >> {:name=>"飛",
# >>  :promoted_name=>"龍",
# >>  :basic_names=>["飛", "rook"],
# >>  :promoted_names=>["龍", "ROOK", "竜"],
# >>  :names=>["飛", "rook", "龍", "ROOK", "竜"],
# >>  :sym_name=>:rook,
# >>  :promotable?=>true,
# >>  :basic_step_vectors=>[],
# >>  :basic_series_vectors=>[nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil],
# >>  :promoted_step_vectors=>
# >>   [[-1, -1], [0, -1], [1, -1], [-1, 0], nil, [1, 0], [-1, 1], [0, 1], [1, 1]],
# >>  :promoted_series_vectors=>[nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil]}
