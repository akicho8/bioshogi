require "spec_helper"

module Bioshogi
  module Formatter
    module Animation
      describe SerialFilenameGenerator do
        it "works" do
          sfg = SerialFilenameGenerator.new
          assert { sfg.name == "_input%04d.png" }
          assert { sfg.next == "PNG24:_input0000.png" }
          assert { sfg.next == "PNG24:_input0001.png" }
          assert { sfg.inspect == "ページ数: 2, 存在ファイル数: 0, ファイル名: _input%04d.png" }
        end
      end
    end
  end
end
