require "./example_helper"

info = Parser.parse(<<~EOT)
*KEY1：value1
KEY2：value2
EOT
info.header.to_h                # => {"*KEY1"=>"value1", "KEY2"=>"value2"}
