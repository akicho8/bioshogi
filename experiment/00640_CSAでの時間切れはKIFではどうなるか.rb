require "./example_helper"

Parser::CsaParser.parse("%TIME_UP").judgment_message # => "まで0手で時間切れにより後手の勝ち"
Parser::CsaParser.parse("%CHUDAN").judgment_message  # => "まで0手で切断により後手の勝ち"
Parser::CsaParser.parse("%TORYO").judgment_message   # => "まで0手で後手の勝ち"
Parser::CsaParser.parse("%ERROR").judgment_message   # => "まで0手でエラーにより後手の勝ち"
Parser::CsaParser.parse("%TSUMI").judgment_message   # => "まで0手で後手の勝ち"
