require "./setup"

info = Parser.parse("")
tp info.pi.header.to_h
tp info.pi.header.entry_all_names
tp info.pi.header.__to_meta_h
tp info.pi.header.to_kisen_a
tp info.pi.header.entry_all_names
tp info.pi.header.tags
puts info.to_ki2
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:29:in `parse': 棋譜のフォーマットが不明です :  (Bioshogi::FileFormatError)
# ~> 	from -:3:in `<main>'
