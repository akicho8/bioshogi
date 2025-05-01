require "benchmark"
require "diff/lcs"

module Bioshogi
  class ExtremeDetect
    def initialize(options = {})
      @options = {
        :limit => nil,
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

    def assert_equal(a, b)
      r = a == b
      unless r
        diff(a, b)
      end

      result[r] += 1
      print r ? "." : "x"
      STDOUT.flush

      unless r
        error_body.open("a") do |e|
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

    def all_transform_test
      info = Parser.parse(@current.read, typical_error_case: :skip)

      # KIF
      v = Parser.parse(info.to_kif)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false)
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false)
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false)
      assert_equal v.to_sfen, info.to_sfen

      # KI2
      v = Parser.parse(info.to_ki2)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false)
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false)
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false)
      assert_equal v.to_sfen, info.to_sfen

      # CSA
      v = Parser.parse(info.to_csa)
      assert_equal v.to_kif(has_header: false), info.to_kif(has_header: false)
      assert_equal v.to_ki2(has_header: false), info.to_ki2(has_header: false)
      assert_equal v.to_csa(has_header: false), info.to_csa(has_header: false)
      assert_equal v.to_sfen, info.to_sfen

      # SFEN
      v = Parser.parse(info.to_sfen)
      assert_equal v.to_kif(has_header: false, has_footer: false), info.to_kif(has_header: false, has_footer: false)
      assert_equal v.to_ki2(has_header: false, has_footer: false), info.to_ki2(has_header: false, has_footer: false)
      assert_equal v.to_csa(has_header: false, has_footer: false), info.to_csa(has_header: false, has_footer: false)
      assert_equal v.to_sfen, info.to_sfen
    end

    def error_body
      @error_body ||= LOG_DIR.join("error_body.log")
    end

    def error_list
      @error_list ||= LOG_DIR.join("error_list.txt")
    end

    def limit
      @limit ||= (@options[:limit].presence || 1000_0000).to_i
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
        files.take(limit)
      end
    end
  end
end
