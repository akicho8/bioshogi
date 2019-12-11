# frozen-string-literal: true
# bioshogi input_parser "76歩"

if $0 == __FILE__
  require "../cli"
end

module Bioshogi
  class Cli
    desc "input_parser", "入力"
    def input_parser(*argv)
      str = argv.join(" ")
      rows = InputParser.scan(str).collect do |str|
        {source: str}.merge(InputParser.match!(str).named_captures)
      end
      tp rows
    end
  end
end

if $0 == __FILE__
  Bioshogi::Cli.start(["input_parser", "68S", "△76歩"])
end
