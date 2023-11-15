require "spec_helper"
require "bioshogi/cli"

module Bioshogi
  describe CLI do
    around do |e|
      capture(:stdout) { e.run }
    end

    it "convert" do
      Bioshogi::CLI.start(["convert", "-f", "ki2", ASSETS_DIR.join("kifu_formats/sample.kif")])
    end

    it "input_match" do
      Bioshogi::CLI.start(["input_match", "68S"])
    end

    it "versus" do
      Bioshogi::CLI.start(["versus", "-t", "0.5", "-n", "1"])
    end

    it "piece" do
      Bioshogi::CLI.start(["piece"])
    end
  end
end
