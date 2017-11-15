require_relative "example_helper"

Parser::Ki2Parser.parse("７六歩 ▲７六歩") # => 
# ~> -:1:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:1:in `<main>'
