require "spec_helper"

RSpec.describe Bioshogi::Analysis::TagBundle do
  before do
    @tag_bundle = Bioshogi::Analysis::TagBundle.new
    @tag_bundle << "片美濃囲い"
    @tag_bundle << "銀美濃"
    @tag_bundle << "ダイヤモンド美濃"
    @tag_bundle << "コーヤン流三間飛車"
    @tag_bundle << "嬉野流"
    @tag_bundle << "入玉"
  end

  describe Bioshogi::Analysis::TagBundle::List do
    it "全部入り" do
      assert { @tag_bundle.defense_infos.collect(&:key) == [:"片美濃囲い", :"銀美濃", :"ダイヤモンド美濃"] }
    end

    it "「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する → やめ" do
      assert { @tag_bundle.defense_infos.normalize.collect(&:key) == [:片美濃囲い, :銀美濃, :ダイヤモンド美濃] }
    end

    it "defense_infos内でエイリアスを含めたすべての名前を取得" do
      assert { @tag_bundle.defense_infos.normalized_names_with_alias == ["片美濃囲い", "銀美濃", "ダイヤモンド美濃"] }
    end

    # it "無駄な先祖をだけを削除した配列を返す" do
    #   tag_bundle = Bioshogi::Analysis::TagBundle.new
    #   tag_bundle << "四間飛車"
    #   tag_bundle << "3→4→3戦法"
    #   assert { tag_bundle.attack_infos.unwant_rejected_ancestors == [Bioshogi::Analysis::AttackInfo["3→4→3戦法"]] }
    # end
  end

  it "all" do
    assert { @tag_bundle.collect(&:size) == [2, 3, 1, 0] }
  end

  it "エイリアスを含めたすべての名前を取得" do
    assert { @tag_bundle.normalized_names_with_alias == ["コーヤン流三間飛車", "コーヤン流", "中田功XP", "嬉野流", "片美濃囲い", "銀美濃", "ダイヤモンド美濃", "入玉"] }
  end

  it "代表とする棋風" do
    assert { @tag_bundle.main_style_info.key == :"変態" }
  end
end
