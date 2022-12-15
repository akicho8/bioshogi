require "./setup"

Parser.parse("unknown\na：1").mi.header.to_h # => {"a"=>"1"}
