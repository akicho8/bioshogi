require "spec_helper"

module Bioshogi
  describe Converter do
    it "棋譜変換できる" do
      output_file = TMP_DIR.join("sample.ki2")
      output_file.existence&.delete
      file = ASSETS_DIR.join("kifu_formats/sample.kif")
      options = { format: "ki2", output_dir: TMP_DIR }
      files = [file]
      capture(:stdout) { Converter.new(files, options).call }
      assert { output_file.exist? }
    end
  end
end
