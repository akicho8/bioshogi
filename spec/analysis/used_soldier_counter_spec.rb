require "~/src/shogi-extend/workbench/setup"
s { User.count }              # => 70
_ { User.count }              # => "0.33 ms"
# >>   User Count (0.4ms)  SELECT COUNT(*) FROM `users`

require "~/src/bioshogi/lib/bioshogi"
