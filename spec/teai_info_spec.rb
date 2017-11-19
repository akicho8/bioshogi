require_relative "spec_helper"

module Bushido
  describe TeaiInfo do
    it "black_mini_soldiers" do
      TeaiInfo["平手"].black_mini_soldiers.collect(&:name).should == ["９七歩", "９九香", "８七歩", "８八角", "８九桂", "７七歩", "７九銀", "６七歩", "６九金", "５七歩", "５九玉", "４七歩", "４九金", "３七歩", "３九銀", "２七歩", "２八飛", "２九桂", "１七歩", "１九香"]
    end
  end
end
