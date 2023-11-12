require "spec_helper"

module Bioshogi
  describe Converter do
    it "works" do
      output_file = TMP_DIR.join("sample.ki2")
      output_file.existence&.delete
      file = ASSETS_DIR.join("kifu_formats/sample.kif")
      options = { format: "ki2", output_dir: TMP_DIR }
      capture(:stdout) { Converter.new([file], options).call }
      assert { output_file.exist? }
    end
  end
end
