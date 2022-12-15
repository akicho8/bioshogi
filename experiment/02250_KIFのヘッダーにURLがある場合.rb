require "./setup"

info = Parser.parse(<<~EOT)
*KEY1：value1
KEY2：value2
EOT
info.mi.header.to_h                # => {"*KEY1"=>"value1", "KEY2"=>"value2"}
