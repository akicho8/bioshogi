require "spec_helper"
require "bioshogi/cli"

module Bioshogi
  describe CLI do
    it "convert" do
      capture(:stdout) do
        Bioshogi::CLI.start(["convert", "-f", "ki2", "../lib/bioshogi/assets/kifu_formats/sample.kif"])
      end
    end
    it "input_checker" do
      capture(:stdout) do
        Bioshogi::CLI.start(["input_checker", "68S"])
      end
    end
  end
end
