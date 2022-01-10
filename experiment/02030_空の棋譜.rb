require "./setup"

info = Parser.parse("")
tp info.header.to_h
tp info.header.entry_all_names
tp info.header.__to_meta_h
tp info.header.to_kisen_a
tp info.header.entry_all_names
tp info.header.tags
puts info.to_ki2
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:29:in `parse': 棋譜のフォーマットが不明です :  (Bioshogi::FileFormatError)
# ~> 	from -:3:in `<main>'
