require "./example_helper"

def assert_equal(a, b)
  if a == b
    puts "OK"
  else
    puts "ERROR"
  end
end

files = Pathname.glob("#{__dir__}/../resources/竜王戦_ki2/*.ki2")
files.each do |file|
  puts file

  info = Parser.parse_file(file)
  kif_str = info.to_kif
  ki2_str = info.to_ki2

  v = Parser.parse(kif_str)
  assert_equal(v.to_kif, kif_str)
  assert_equal(v.to_ki2, ki2_str)

  v = Parser.parse(ki2_str)
  assert_equal(v.to_kif, kif_str)
  assert_equal(v.to_ki2, ki2_str)
end
