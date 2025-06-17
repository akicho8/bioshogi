require "#{__dir__}/setup"

Dimension.default_size?                             # => true
Dimension.current_size                              # => [9, 9]
Dimension.change([2, 3]) { Dimension.current_size } # => [2, 3]
Dimension.current_size                              # => [9, 9]
