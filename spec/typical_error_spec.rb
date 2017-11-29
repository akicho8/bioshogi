require_relative "spec_helper"

module Bushido
  describe TypicalError do
    describe "二歩の反則負け" do
      before do
        @file = "#{__dir__}/double_pawn.ki2"
      end

      it "読み込むことはできる" do
        Parser.file_parse(@file)
      end

      it "変換するときに例外が出る" do
        expect { Parser.file_parse(@file).to_kif }.to raise_error(DoublePawn)
      end

      it "オプションをつければ例外がでない" do
        info = Parser.file_parse(@file, double_pawn_case: :skip)
        assert info.to_kif
        assert info.to_ki2
        assert !info.to_csa.match?(/【反則】/)
      end

      it "エラー情報を棋譜に埋め込む" do
        info = Parser.file_parse(@file, double_pawn_case: :embed)
        assert info.to_kif
        assert info.to_ki2
        assert info.to_csa.match?(/【反則】/)
      end
    end

    describe "手番が異なる" do
      before do
        @body = "△７六歩"
      end

      it "変換するときに例外が出る" do
        expect { Parser.parse(@body).to_kif }.to raise_error(TebanchigauError)
      end

      it "オプションをつければ例外がでない" do
        info = Parser.parse(@body, double_pawn_case: :skip)
        assert info.to_kif
        assert info.to_ki2
        assert !info.to_csa.match?(/【反則】/)
      end

      it "エラー情報を棋譜に埋め込む" do
        info = Parser.parse(@body, double_pawn_case: :embed)
        assert info.to_kif
        assert info.to_ki2
        assert info.to_csa.match?(/【反則】/)
      end
    end
  end
end
