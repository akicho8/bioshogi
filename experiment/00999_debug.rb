require "./setup"

info = Parser.parse("68S")
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/kif_builder.rb:23:in `build_before': undefined method `clock_exist?' for #<Bioshogi::Formatter::Exporter:0x00007fc744bcabe8> (NoMethodError)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kakinoki_builder.rb:24:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/exporter.rb:15:in `to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:9:in `to_kif'
# ~> 	from -:4:in `<main>'
