require "spec_helper"

module Bioshogi
  describe CommonError do
    describe "二歩の反則負け" do
      before do
        @file = "#{__dir__}/files/反則二歩.ki2"
      end

      it "読み込むことはできる" do
        Parser.file_parse(@file)
      end

      it "変換するときに例外が出る" do
        expect { Parser.file_parse(@file).to_kif }.to raise_error(DoublePawnCommonError)
      end

      it "オプションをつければ例外がでない" do
        info = Parser.file_parse(@file, typical_error_case: :skip)
       assert { info.to_kif }
       assert { info.to_ki2 }
       assert { !info.to_csa.match?(/【反則】/) }
      end

      it "エラー情報を棋譜に埋め込む" do
        info = Parser.file_parse(@file, typical_error_case: :embed)
       assert { info.to_kif }
       assert { info.to_ki2 }
       assert { info.to_csa.match?(/【反則】/) }
      end
    end

    describe "手番が異なる" do
      before do
        @body = "△７六歩"
      end

      it "変換するときに例外が出る" do
        expect { Parser.parse(@body).to_kif }.to raise_error(DifferentTurnCommonError)
      end

      it "オプションをつければ例外がでない" do
        info = Parser.parse(@body, typical_error_case: :skip)
       assert { info.to_kif }
       assert { info.to_ki2 }
       assert { !info.to_csa.match?(/【反則】/) }
      end

      it "エラー情報を棋譜に埋め込む" do
        info = Parser.parse(@body, typical_error_case: :embed)
       assert { info.to_kif }
       assert { info.to_ki2 }
       assert { info.to_csa.match?(/【反則】/) }
      end
    end
  end
end
