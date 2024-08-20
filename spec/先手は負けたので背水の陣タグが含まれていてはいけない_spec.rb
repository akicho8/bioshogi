require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      info = Parser.file_parse("#{__dir__}/files/後手入玉勝ち_先手が指し終わったタイミングで後手が勝つ特殊なケース.csa")
      assert { !info.to_kif.match?(/先手の備考：.*背水の陣/) }
    end
  end
end
