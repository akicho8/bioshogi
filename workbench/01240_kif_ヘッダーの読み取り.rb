require "#{__dir__}/setup"

Parser.parse("unknown\na：1").pi.header.to_h # => {"a"=>"1"}
