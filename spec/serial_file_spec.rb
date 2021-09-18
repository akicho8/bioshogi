require "spec_helper"

module Bioshogi
  describe SerialFile do
    it "works" do
      sfile = SerialFile.new
      assert { sfile.name == "_input%04d.png" }
      assert { sfile.next == "_input0000.png" }
      assert { sfile.next == "_input0001.png" }
      assert { sfile.inspect == "ページ数: 2, 存在ファイル数: 0, ファイル名: _input%04d.png" }
    end
  end
end
# >> .
# >> 
# >> Finished in 0.0139 seconds (files took 1.51 seconds to load)
# >> 1 example, 0 failures
# >> 
