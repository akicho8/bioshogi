require "spec_helper"

module Bioshogi
  describe do
    it "先手は負けたので背水の陣タグが含まれていてはいけない" do
      info = Parser.file_parse("#{__dir__}/files/後手入玉勝ち_先手が指し終わったタイミングで後手が勝つ特殊なケース.csa")
      assert { !info.to_kif.match?(/先手の備考：.*背水の陣/) }
    end

    it "先手切断され勝ち_後手大駒全ブッチ後相手の手番で切断したので負けであり「背水の陣」は得られない" do
      info = Parser.file_parse("#{__dir__}/files/先手切断され勝ち_後手大駒全ブッチ後相手の手番で切断したので負けであり「背水の陣」は得られない.csa")
      assert { !info.to_kif.match?(/後手の備考：.*背水の陣/) }
    end
  end
end
