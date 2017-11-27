require "./example_helper"
require 'active_support/core_ext/benchmark'

@error_file = Pathname("__error.txt")
@error_file.unlink rescue nil
@result = Hash.new(0)

def assert_equal(a, b)
  r = a == b
  @result[r] += 1
  print r ? "." : "x"
  STDOUT.flush
end

seconds = Benchmark.realtime do
  files = Pathname.glob("../../2chkifu/00001/*").take((ARGV.first || 1000_0000).to_i)
  files.each do |file|
    begin
      info = Parser.parse_file(file)
      kif_str = info.to_kif
      ki2_str = info.to_ki2
      csa_str = info.to_csa

      v = Parser.parse(kif_str)
      assert_equal(v.to_kif, kif_str)
      assert_equal(v.to_ki2, ki2_str)
      assert_equal(v.to_csa, csa_str)

      v = Parser.parse(ki2_str)
      assert_equal(v.to_kif, kif_str)
      assert_equal(v.to_ki2, ki2_str)
      assert_equal(v.to_csa, csa_str)

      v = Parser.parse(csa_str)
      assert_equal(v.to_kif(header_skip: true), info.to_kif(header_skip: true))
      assert_equal(v.to_ki2(header_skip: true), info.to_ki2(header_skip: true))
      assert_equal(v.to_csa(header_skip: true), info.to_csa(header_skip: true))
    rescue => error
      @error_file.open("a") do |e|
        e.puts "-" * 80
        e.puts file.expand_path
        e.puts error.class.name
        e.puts error.message
        e.puts error.backtrace
      end
      break
    end
  end
end

puts
p seconds
p @result
