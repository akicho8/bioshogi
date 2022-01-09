# transform/* のファイルを検証
#
# ▼これだけ実行
# rake spec:transform
#
# ▼あれこれ表示
# VERBOSE=1 rake spec:transform
#
# ▼比較するファイルをいったん生成
# TRANSFORM_OUTPUT=1 rake spec:transform
#
require "spec_helper"

module Bioshogi
  describe "変換", transform: true do
    it "works" do
      trace = -> s {
        if ENV["VERBOSE"]
          puts s
        end
      }
      types = [:kif, :ki2, :bod, :csa, :sfen, :akf]
      wildcard = "**/source.*"
      Pathname(__dir__).glob("transform/**/source.*") do |e|
        info = Parser.parse(e)
        trace.call "IN: #{e.dirname.basename}"
        if ENV["TRANSFORM_OUTPUT"]
          puts "read: #{e}"
          types.each do |type|
            file = e.dirname.join("expected.#{type}")
            actual = transform_to(info, type)
            file.write(actual)
            puts "write: #{file}"
          end
        end
        e.dirname.glob("expected.*") do |expected_file|
          type = expected_file.extname.slice(/\w+/)
          actual = transform_to(info, type)
          expected = expected_file.read
          actual = actual.strip
          expected = expected.strip
          trace.call "  -> #{expected_file.extname}"
          expect(actual).to eq(expected) # diff になるので power assert にしない方がよい
        end
      end
    end

    def transform_to(info, type)
      begin
        s = info.public_send("to_#{type}")
      rescue => error
        s = error_to_text(error)
      end
      unless s.kind_of?(String)
        s = s.pretty_inspect # or to_yaml
      end
      s
    end

    def error_to_text(error)
      [
        error.class.name,
        "\n",
        error.message,
      ].join.strip + "\n"
    end
  end
end
