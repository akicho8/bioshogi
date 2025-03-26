require "spec_helper"

RSpec.describe Bioshogi::Formatter::Animation::SerialFilenameGenerator do
  it "works" do
    sfg = Bioshogi::Formatter::Animation::SerialFilenameGenerator.new
    assert { sfg.name == "_input%04d.png" }
    assert { sfg.next == "PNG24:_input0000.png" }
    assert { sfg.next == "PNG24:_input0001.png" }
    assert { sfg.inspect == "ページ数: 2, 存在ファイル数: 0, ファイル名: _input%04d.png" }
  end
end
