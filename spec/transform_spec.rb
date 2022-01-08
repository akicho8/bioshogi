# TRANSFORM_OUTPUT=1 bundle exec rspec spec/transform_spec.rb -f d
# VERBOSE=1 bundle exec rspec spec/transform_spec.rb -f d
#
# rake spec:transform
# TRANSFORM_OUTPUT=1 rake spec:transform
# VERBOSE=1 rake spec:transform

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
          # puts actual
          expected = expected_file.read
          actual = actual.strip
          expected = expected.strip
          trace.call "  -> #{expected_file.extname}"
          # assert { actual == expected }
          expect(actual).to eq(expected)
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
        s = s.pretty_inspect
        # s = s.to_yaml
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

  # describe "変換" do
  #   types = [:kif, :ki2, :bod, :csa, :sfen]
  #   wildcard = "**/source.*"
  #   Pathname(__dir__).glob("transform/**/source.*") do |e|
  #     info = Parser.parse(e)
  #     describe "IN: #{e.dirname.basename}" do
  #       if ENV["TRANSFORM_OUTPUT"]
  #         types.each do |type|
  #           file = e.dirname.join("expected.#{type}")
  #           file.write(info.public_send("to_#{type}"))
  #           puts "write: #{file}"
  #         end
  #       end
  #       e.dirname.glob("expected.*") do |expected_file|
  #         type = expected_file.extname.slice(/\w+/)
  #         actual = info.public_send("to_#{type}")
  #         # puts actual
  #         expected = expected_file.read
  #         actual = actual.strip
  #         expected = expected.strip
  #         it "OUT: #{expected_file.extname}" do
  #           assert { actual == expected }
  #         end
  #       end
  #     end
  #   end
  # end
end
