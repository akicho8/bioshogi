require "./setup"

info = Parser.parse("")
tp info.header.to_h
tp info.header.entry_all_names
tp info.header.meta_info
tp info.header.__to_meta_h
tp info.header.to_kisen_a
tp info.header.entry_all_names
tp info.header.tags
puts info.to_ki2
# ~> -:5:in `<main>': undefined method `entry_all_names' for #<Bioshogi::Parser::Header:0x00007ff6df059fa0 @object={}> (NoMethodError)
# ~> Did you mean?  to_enum
