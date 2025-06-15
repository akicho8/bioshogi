require "spec_helper"

RSpec.describe Bioshogi::Analysis::TagIndex do
  describe "すべての戦法の判定", tactic: true do
    Bioshogi::Analysis::TagIndex.values.each do |e|
      it e.key do
        e.reference_files.each do |file|
          info = Bioshogi::Parser.parse(file)
          info.formatter.container_run_once
          assert { info.formatter.container.normalized_names_with_alias.include?(e.key.to_s) }
        end
      end
    end
  end

  it "すべての戦法や囲いのスタイルを取得できる" do
    assert { Bioshogi::Analysis::TagIndex.values.all?(&:style_info) }
  end

  describe "flat_lookup" do
    it "works" do
      assert { Bioshogi::Analysis::TagIndex.lookup("金底の歩") }
    end
    it "文字列でなくても to_s してから探す" do
      o = Object.new
      def o.to_s; "金底の歩"; end
      assert { Bioshogi::Analysis::TagIndex.lookup(o) }
    end
  end

  describe "flat_fetch" do
    it "works" do
      assert { Bioshogi::Analysis::TagIndex.fetch("金底の歩") }
    end
  end

  it "fuzzy_flat_lookup" do
    assert { Bioshogi::Analysis::TagIndex.fuzzy_lookup("嬉野") }
    assert { Bioshogi::Analysis::TagIndex.fuzzy_lookup("角頭歩") }
    assert { Bioshogi::Analysis::TagIndex.fuzzy_lookup("アヒル") }
    assert { Bioshogi::Analysis::TagIndex.fuzzy_lookup("阪田流向かい飛車") }
  end

  it "values" do
    assert { Bioshogi::Analysis::TagIndex.values.include?(Bioshogi::Analysis::AttackInfo.fetch("棒銀")) }
  end

  it "values_hash" do
    assert { Bioshogi::Analysis::TagIndex.values_hash[:"棒銀"] }
    assert { Bioshogi::Analysis::TagIndex.values_hash[:"美濃囲い"]       }
  end

  it "name" do
    assert { Bioshogi::Analysis::TacticInfo[:attack].name == "戦法" }
  end

  it ".piece_hash_table" do
    assert { Bioshogi::Analysis::TagIndex.piece_hash_table[[:pawn, false, true]].include?(Bioshogi::Analysis::TechniqueInfo["金底の歩"]) }
  end
end
