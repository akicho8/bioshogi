require "./setup"

Parser.parse("unknown\na：1").header.to_h # => {"a"=>"1"}
