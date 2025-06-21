require "#{__dir__}/setup"
V.cross_vectors                # => [<[0, -1]>, <[1, 0]>, <[0, 1]>, <[-1, 0]>]
V.outer_vectors               # => [<[0, -1]>, <[1, 0]>, <[0, 1]>, <[-1, 0]>, <[-1, -1]>, <[1, 1]>, <[1, -1]>, <[-1, 1]>]
V.keima_vectors                 # => [<[-1, -2]>, <[1, -2]>]
V.wariuchi_vectors              # => [<[-1, 1]>, <[1, 1]>]
V.ikkenryu_cross_vectors              # => [<[-2, 0]>, <[2, 0]>, <[0, -2]>, <[0, 2]>]
V.ginbasami_verctors            # => [[<[1, 0]>, <[2, 0]>, <[2, -1]>], [<[-1, 0]>, <[-2, 0]>, <[-2, -1]>]]
V.tsugikei_vectors              # => [<[1, 2]>, <[-1, 2]>]
V.tasuki_vectors                # => [[<[-1, -1]>, <[1, 1]>], [<[1, -1]>, <[-1, 1]>]]

V.right * V.reverse_x           # => <[-1, 0]>
V.left                          # => <[-1, 0]>

V.reverse_y                # => <[1, -1]>
