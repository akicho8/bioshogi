require "#{__dir__}/setup"

info = Parser.parse(<<~EOT)
*KEY1：value1
KEY2：value2
EOT
info.pi.header.to_h                # => {"*KEY1"=>"value1", "KEY2"=>"value2"}
