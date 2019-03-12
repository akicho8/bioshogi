require_relative "spec_helper"

module Warabi
  describe FooTesujiInfo do
    it "金底の歩" do
      mediator = Mediator.new
      mediator.placement_from_bod(<<~EOT)
後手の持駒：歩
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・v金 ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
先手の持駒：歩
手数＝1

先手番
EOT
      mediator.params[:skill_monitor_enable] = true
      mediator.execute("31歩打")
      assert { mediator.hand_logs.last.skill_set.foo_tesuji_infos.first.key == :"金底の歩" }
    end
  end
end
