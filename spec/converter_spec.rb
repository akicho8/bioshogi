require "spec_helper"

describe Bioshogi::Converter do
  it "棋譜変換できる" do
    output_file = Bioshogi::TMP_DIR.join("sample.ki2")
    output_file.existence&.delete
    file = Bioshogi::ASSETS_DIR.join("kifu_formats/sample.kif")
    options = { format: "ki2", output_dir: Bioshogi::TMP_DIR }
    files = [file]
    capture(:stdout) { Bioshogi::Converter.new(files, options).call }
    assert { output_file.exist? }
  end
end
