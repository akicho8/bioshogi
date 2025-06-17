require "#{__dir__}/setup"

Pathname("/Users/ikeda/Downloads/kif_dr3").glob("*.kif").each do |e|
  info = Parser.parse(e.read)
  e.write(info.to_kif)
end
