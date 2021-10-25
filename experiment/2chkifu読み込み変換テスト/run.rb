require "../setup"

class App
  def run
    # Bioshogi.config[:skill_monitor_enable] = false

    @error_body = Pathname("error_body.log")
    @error_body.unlink rescue nil
    @result = Hash.new(0)

    @error_list = Pathname("error_list.txt")
    if @error_list.exist?
      @target_files = @error_list.readlines.reject { |e|e.match?("#") }.collect { |e| Pathname(e.strip) }
    else
      @target_files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}").sort
    end

    # @target_files = "~/src/2chkifu/00001/00002.KI2"

    @target_files = Array(@target_files).take((ARGV.first || 1000_0000).to_i)
    seconds = Benchmark.realtime do
      @target_files.each do |file|
        @current = Pathname(file).expand_path

        begin
          info = Parser.file_parse(file, typical_error_case: :skip)
          kif_str = info.to_kif
          ki2_str = info.to_ki2
          csa_str = info.to_csa
          sfen_str = info.to_sfen

          # KIF
          v = Parser.parse(kif_str)
          assert_equal v.to_kif, kif_str
          assert_equal v.to_ki2, ki2_str
          assert_equal v.to_csa, csa_str
          assert_equal v.to_sfen, sfen_str

          # KI2
          v = Parser.parse(ki2_str)
          assert_equal v.to_kif, kif_str
          assert_equal v.to_ki2, ki2_str
          assert_equal v.to_csa, csa_str
          assert_equal v.to_sfen, sfen_str

          # CSA
          v = Parser.parse(csa_str)
          assert_equal v.to_kif(header_skip: true), info.to_kif(header_skip: true)
          assert_equal v.to_ki2(header_skip: true), info.to_ki2(header_skip: true)
          assert_equal v.to_csa(header_skip: true), info.to_csa(header_skip: true)
          assert_equal v.to_sfen(header_skip: true), info.to_sfen(header_skip: true)

          # SFEN
          v = Parser.parse(sfen_str)
          assert_equal v.to_kif(header_skip: true, footer_skip: true), info.to_kif(header_skip: true, footer_skip: true)
          assert_equal v.to_ki2(header_skip: true, footer_skip: true), info.to_ki2(header_skip: true, footer_skip: true)
          # assert_equal v.to_csa(header_skip: true), info.to_csa(header_skip: true)
          # assert_equal v.to_sfen(header_skip: true), info.to_sfen(header_skip: true)
        rescue => error
          @result[error.class.name] += 1

          if false
            if error.kind_of?(Bioshogi::DoublePawnCommonError)
              print "_"
              next
            end
          end

          print "E"
          @error_body.open("a") do |e|
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
  end

  def assert_equal(a, b)
    r = a == b
    unless r
      diff(a, b)
    end

    @result[r] += 1
    print r ? "." : "x"
    STDOUT.flush

    unless r
      @error_body.open("a") do |e|
        e.puts "-" * 80
        e.puts @current.expand_path
        e.puts caller
        e.puts "◆a"
        e.puts a
        e.puts "◆b"
        e.puts b
      end
    end
  end

  def diff(str1, str2)
    require "diff/lcs"
    diff = Diff::LCS.sdiff(*[str1, str2].collect { |e| e.lines.collect(&:rstrip) }).each_with_object("") do |e, m|
      if e.old_element != e.new_element
        m << "- #{e.old_element}\n" if e.old_element
        m << "+ #{e.new_element}\n" if e.new_element
      end
    end
    puts "--------------------------------------------------------------------------------"
    puts diff
    puts "--------------------------------------------------------------------------------"
  end
end

App.new.run
