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
    trace = -> s {
      if ENV["VERBOSE"]
        puts s
      end
    }

    error_as_text = -> error {
      [
        "ERROR: #{error.class.name}",
        "\n",
        error.message,
      ].join.strip + "\n"
    }

    transform_to = -> info, type {
      begin
        s = info.public_send("to_#{type}")
      rescue => error
        s = error_as_text.(error)
      end
      if !s.kind_of?(String)
        s = s.pretty_inspect # or to_yaml
      end
      s
    }

    types = [:kif, :ki2, :bod, :csa, :sfen, :akf]
    wildcard = "**/source.*"
    Pathname(__dir__).glob("transform/**/source.*") do |e|
      describe e.dirname.basename do
        info = Parser.parse(e, typical_error_case: :embed)
        trace.call "IN: #{e.dirname.basename}"
        if ENV["TRANSFORM_OUTPUT"]
          puts "    read: #{e}"
          types.each do |type|
            file = e.dirname.join("expected.#{type}")
            actual = transform_to.(info, type)
            file.write(actual)
            puts "      write: #{file}"
          end
        end
        e.dirname.glob("expected.*") do |expected_file|
          it expected_file do
            type = expected_file.extname.slice(/\w+/)
            actual = transform_to.(info, type)
            e.dirname.join("actual.#{type}").write(actual)
            expected = expected_file.read
            actual = actual.strip
            expected = expected.strip
            trace.call "  -> #{expected_file.extname}"
            expect(actual).to eq(expected) # diff になるので power assert にしない方がよい
          end
        end
      end
    end
  end
end
