require "../setup"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
後手の持駒：歩
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ 金v金|
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
mediator.execute("11歩打")
pp mediator.hand_logs.last
pp mediator.hand_logs.last.skill_set.technique_infos.first.key == :"金底の歩"
# ~> -:26:in `<main>': undefined method `key' for nil:NilClass (NoMethodError)
# >> #<Bioshogi::HandLog:0x00007fe2478352f8
# >>  @candidate_soldiers=[],
# >>  @drop_hand=<△１一歩打>,
# >>  @handicap=false,
# >>  @move_hand=nil,
# >>  @personal_clock=
# >>   #<Bioshogi::ChessClock::PersonalClock:0x00007fe247835618
# >>    @total_seconds=0,
# >>    @used_seconds=0>,
# >>  @place_same=nil,
# >>  @skill_set=#<Bioshogi::SkillSet:0x00007fe24782ef98>>
