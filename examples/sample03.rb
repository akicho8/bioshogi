# -*- coding: utf-8 -*-
#
# 駒の情報
#

require "bundler/setup"
require "bushido"
include Bushido

piece = Piece.get("角")
piece.name              # => "角"
piece.promoted_name     # => "馬"
piece.basic_names       # => ["角", "bishop"]
piece.promoted_names    # => ["馬", "BISHOP"]
piece.names             # => ["角", "bishop", "馬", "BISHOP"]
piece.sym_name          # => :bishop
piece.promotable?       # => true
piece.basic_vectors1    # => []
piece.basic_vectors2    # => [[-1, -1], nil, [1, -1], nil, nil, nil, [-1, 1], nil, [1, 1]]
piece.promoted_vectors1 # => [[-1, -1], [0, -1], [1, -1], [-1, 0], nil, [1, 0], [-1, 1], [0, 1], [1, 1]]
piece.promoted_vectors2 # => [[-1, -1], nil, [1, -1], nil, nil, nil, [-1, 1], nil, [1, 1]]
