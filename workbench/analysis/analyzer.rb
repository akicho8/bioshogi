require "./setup"
info = Parser.parse("48玉 34歩 76歩 88角成")
info.container.players.count    # => 2
