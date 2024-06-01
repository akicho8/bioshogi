require "../setup"

Bioshogi::Parser::Ki2Parser.accept?("")       # => nil
Parser.parse("").class rescue $!              # => #<Bioshogi::FileFormatError: 棋譜のフォーマットが不明です : >
Bioshogi::Parser::Ki2Parser.accept?("68銀")   # => true
Bioshogi::Parser::Ki2Parser.accept?(" 68銀")  # => true
Bioshogi::Parser::Ki2Parser.accept?("　68銀") # => true
