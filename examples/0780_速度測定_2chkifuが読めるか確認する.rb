require "./example_helper"
require 'active_support/core_ext/benchmark'

# Bushido.config[:skill_set_flag] = false

@error_file = Pathname("__error.log")
@error_file.unlink rescue nil
@result = Hash.new(0)

def assert_equal(a, b)
  r = a == b
  @result[r] += 1
  print r ? "." : "x"
  STDOUT.flush

  unless r
    @error_file.open("a") do |e|
      e.puts "-" * 80
      e.puts @current.expand_path
      e.puts caller
      e.puts a
      e.puts b
    end
  end
end

@check_file = Pathname("check_file.txt")
if @check_file.exist?
  files = @check_file.readlines.collect {|e| Pathname(e.strip) }
else
  files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}").sort
end

files = files.take((ARGV.first || 1000_0000).to_i)
seconds = Benchmark.realtime do
  files.each do |file|
    @current = file

    begin
      info = Parser.file_parse(file, typical_error_case: :skip)
      kif_str = info.to_kif
      ki2_str = info.to_ki2
      csa_str = info.to_csa

      v = Parser.parse(kif_str)
      assert_equal v.to_kif, kif_str
      assert_equal v.to_ki2, ki2_str
      assert_equal v.to_csa, csa_str

      v = Parser.parse(ki2_str)
      assert_equal v.to_kif, kif_str
      assert_equal v.to_ki2, ki2_str
      assert_equal v.to_csa, csa_str

      v = Parser.parse(csa_str)
      assert_equal v.to_kif(header_skip: true), info.to_kif(header_skip: true)
      assert_equal v.to_ki2(header_skip: true), info.to_ki2(header_skip: true)
      assert_equal v.to_csa(header_skip: true), info.to_csa(header_skip: true)
    rescue => error
      @result[error.class.name] += 1

      if false
        if error.kind_of?(Bushido::DoublePawnError)
          print "_"
          next
        end
      end

      print "E"
      @error_file.open("a") do |e|
        e.puts "-" * 80
        e.puts file.expand_path
        e.puts error.class.name
        e.puts error.message
        e.puts Time.now
        e.puts error.backtrace
      end
    end
  end
end

puts
p seconds
p @result
