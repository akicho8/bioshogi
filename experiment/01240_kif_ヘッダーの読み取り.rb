require "./example_helper"

Parser.parse("unknown\na：1").header.to_h # => {"a"=>"1"}
