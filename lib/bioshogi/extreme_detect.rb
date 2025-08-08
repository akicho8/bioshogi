require "benchmark"
require "diff/lcs"

module Bioshogi
  class ExtremeDetect
    def initialize(options = {})
      @options = {
        :max => ENV["MAX"],
      }.merge(options)
    end

    def call
      # Bioshogi.config[:analysis_feature] = false

      error_body.delete rescue nil
      result = Hash.new(0)

      seconds = Benchmark.realtime do
        target_files.each do |file|
          @current = Pathname(file).expand_path
          begin
            all_transform_test
          rescue => error
            result[error.class.name] += 1

            if false
              if error.kind_of?(Bioshogi::DoublePawnCommonError)
                print "_"
                next
              end
            end

            print "E"
            error_body.open("a") do |e|
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
      p result
    end

    def assert_equal(a, b, messsage = nil)
      if true
        # sfen になると情報が欠けて指し手だけから「穴熊の姿焼き」が判定できないため
        a = a.gsub(/\*.*穴熊の姿焼き.*\R/, "")
        b = b.gsub(/\*.*穴熊の姿焼き.*\R/, "")
      end

      r = a == b
      unless r
        diff_str = diff(a, b, messsage)
        puts diff_str
      end

      result[r] += 1
      print r ? "." : "x"
      STDOUT.flush

      unless r
        error_body.open("a") do |e|
          e.puts "-" * 80
          e.puts @current.expand_path
          e.puts diff_str
          e.puts caller
          e.puts "◆a"
          e.puts a
          e.puts "◆b"
          e.puts b
        end
      end
    end

    def diff(str1, str2, messsage)
      diff = Diff::LCS.sdiff(*[str1, str2].collect { |e| e.lines.collect(&:rstrip) }).each_with_object("") do |e, m|
        if e.old_element != e.new_element
          m << "- #{e.old_element}\n" if e.old_element
          m << "+ #{e.new_element}\n" if e.new_element
        end
      end
      str = []
      str << "-------------------------------------------------------------------------------- #{messsage}\n"
      str << diff
      str << "--------------------------------------------------------------------------------\n"
      str.join
    end

    def all_transform_test
      info = Parser.parse(@current.read, typical_error_case: :skip)

      # KIF
      v = Parser.parse(info.to_kif)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false), "kif → kif"
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false), "kif → ki2"
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false), "kif → csa"
      assert_equal v.to_sfen, info.to_sfen, "kif → sfen"

      # KI2
      v = Parser.parse(info.to_ki2)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false), "ki2 → kif"
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false), "ki2 → ki2"
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false), "ki2 → csa"
      assert_equal v.to_sfen, info.to_sfen, "ki2 → sfen"

      # CSA
      v = Parser.parse(info.to_csa)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false), "csa → kif"
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false), "csa → ki2"
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false), "csa → csa"
      assert_equal v.to_sfen, info.to_sfen, "csa → sfen"

      # SFEN
      v = Parser.parse(info.to_sfen)
      assert_equal v.to_kif(has_header: false, has_footer: false), info.to_kif(has_header: false, has_footer: false), "sfen → kif"
      assert_equal v.to_ki2(has_header: false, has_footer: false), info.to_ki2(has_header: false, has_footer: false), "sfen → ki2"
      assert_equal v.to_csa(has_header: false, has_footer: false), info.to_csa(has_header: false, has_footer: false), "sfen → csa"
      assert_equal v.to_sfen, info.to_sfen, "sfen → sfen"
    end

    def error_body
      @error_body ||= LOG_DIR.join("error_body.log")
    end

    def error_list
      @error_list ||= LOG_DIR.join("error_list.txt")
    end

    def max
      @max ||= (@options[:max].presence || 1000_0000).to_i
    end

    def result
      @result ||= Hash.new(0)
    end

    def target_files
      @target_files ||= yield_self do
        if error_list.exist?
          files = error_list.readlines.reject { |e|e.match?("#") }.collect { |e| Pathname(e.strip) }
        else
          files = ROOT.glob("../../2chkifu/**/*.{ki2,KI2}").sort # ~/src/2chkifu
        end
        files.take(max)
      end
    end
  end
end
