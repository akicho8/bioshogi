require "./example_helper"

Pathname.glob("囲い/アヒル囲い.*".encode("UTF-8", "UTF8-MAC"))   # => [#<Pathname:囲い/アヒル囲い.kif>]

Pathname.glob("囲い/ボナンザ囲い.{kif,ki2}") # => [#<Pathname:囲い/ボナンザ囲い.kif>]

Pathname.glob("囲い/ダイヤモンド美濃.*")   # => []
Pathname.glob("囲い/ダイヤモンド美濃.kif") # => [#<Pathname:囲い/ダイヤモンド美濃.kif>]
