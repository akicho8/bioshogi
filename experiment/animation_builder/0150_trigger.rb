require "../setup"
require 'active_support/core_ext/benchmark'
require "rmagick"
# @sfen = "position startpos moves 7g7f 8c8d 2g2f"
# @sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g 5c5d 2h5h 6b5c 7i6h 5a4b 5i4h 3a3b 4h3h 4c4d 5f5e 3b4c 5e5d 4c5d 6h5g 5d6e 5g5f 6e7f 5f5e 7f6g+ P*5d 5c6b 5h5f 6g7g 8i7g B*3d 5f6f P*5b 6i7i 8b8d 5e4d 8d7d P*7h 7d5d S*4c 3d4c 4d4c+ 4b4c B*7f 5b5c 7i6h 4c3b 6h5h P*4c 7f5d 5c5d 8g8f B*7i 8f8e P*8b 6f8f 7i3e+ 8e8d S*7b 8f8i 3e4e P*6g 7c7d 9g9f 4e5f 8i8f 5f5e 9f9e 5e6d 8f8i 7d7e 7g8e 5d5e 8e9c+ 8a9c 9e9d P*9h 9i9h 6d6e 8i8f 6e9h 9d9c+ 9a9c R*9a 9h6e 9a9c+ 5e5f 5h4h L*9b 9c8b P*8a N*7g 6e7d 8b9a S*8b 9a8b 8a8b S*6e 7d9f 8f5f 9f7h 7g8e 7h6g P*7c 7b8a P*9c 6c6d P*6h 6g8e 9c9b+ 8a9b 7c7b+ 6a7b 6e5d N*4b 5d5c+ P*5d 5c6b 7b6b L*2f R*6i L*2e N*3a 5f4f S*3d 3g3f 6b5c 2i3g 4c4d 4f5f 2c2d 2e2d P*2c 3f3e 3d3e 2d2c+ 3a2c 2f2c+ 3b2c P*3f 3e2d 5f5i 6i6h+ 1g1f L*3d N*2h 4d4e 5i5h 6h7g 2g2f 1c1d 2f2e 2d1c 3g4e 5c4d S*4f P*2f 4e5c+ L*4e 4f5g 8e7d P*6e 7d6e P*5f 5d5e 4h3g 5e5f 5g4h P*4f 3g4f 4e4f"
# @sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g"
@sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g 5c5d 2h5h 6b5c 7i6h 5a4b 5i4h 3a3b 4h3h 4c4d 5f5e 3b4c 5e5d 4c5d 6h5g 5d6e 5g5f 6e7f 5f5e 7f6g+ P*5d 5c6b 5h5f 6g7g 8i7g B*3d 5f6f P*5b 6i7i 8b8d"
info = Parser.parse(@sfen)
mediator = info.mediator_for_image
list = Magick::ImageList.new
info.move_infos.each.with_index do |e|
  mediator.execute(e[:input])
  p mediator.hand_logs.last
  p mediator.outbreak_turn
end
# >> #<Bioshogi::HandLog:0x00007f8c7b761ec0 @drop_hand=nil, @move_hand=<△８四歩(83)>, @candidate=nil, @place_same=nil, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7620f0>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b761f88 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b768a18 @drop_hand=nil, @move_hand=<▲７六歩(77)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b768c20>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b768b30 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b770628 @drop_hand=nil, @move_hand=<△６二銀(71)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b770b50>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b770718 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b782c60 @drop_hand=nil, @move_hand=<▲５六歩(57)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b783110>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b782fa8 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b789e20 @drop_hand=nil, @move_hand=<△８五歩(84)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b78a0c8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b78a050 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7990c8 @drop_hand=nil, @move_hand=<▲７七角(88)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7991b8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b799168 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7a0e90 @drop_hand=nil, @move_hand=<△５四歩(53)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7a0fd0>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7a0f30 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7a8780 @drop_hand=nil, @move_hand=<▲５八飛(28)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7a8820>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7a87d0 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7b2cf8 @drop_hand=nil, @move_hand=<△５三銀(62)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7b2e10>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7b2d98 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7b9530 @drop_hand=nil, @move_hand=<▲６八銀(79)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7b95f8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7b95a8 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7e2500f0 @drop_hand=nil, @move_hand=<△４二玉(51)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e250230>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e2501b8 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7c3878 @drop_hand=nil, @move_hand=<▲４八玉(59)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7c3968>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7c38f0 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7c00d8 @drop_hand=nil, @move_hand=<△３二銀(31)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7c0308>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7c0178 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7d0898 @drop_hand=nil, @move_hand=<▲３八玉(48)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7d0a00>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7d0988 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7e3538 @drop_hand=nil, @move_hand=<△４四歩(43)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7e3718>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7e36a0 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7ea2e8 @drop_hand=nil, @move_hand=<▲５五歩(56)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7ea388>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7ea338 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7f3320 @drop_hand=nil, @move_hand=<△４三銀(32)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7f33e8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7f3398 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7b7f8208 @drop_hand=nil, @move_hand=<▲５四歩(55)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7b7f82a8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7b7f8258 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7ea12658 @drop_hand=nil, @move_hand=<△５四銀(43)>, @candidate=nil, @place_same=true, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea12798>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea126d0 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7e2628e0 @drop_hand=nil, @move_hand=<▲５七銀(68)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e262980>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e262930 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7e26a0b8 @drop_hand=nil, @move_hand=<△６五銀(54)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e26a518>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e26a478 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7ea1a998 @drop_hand=nil, @move_hand=<▲５六銀(57)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea1aa38>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea1a9e8 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7ea21e78 @drop_hand=nil, @move_hand=<△７六銀(65)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea20528>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea20320 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c7ea31170 @drop_hand=nil, @move_hand=<▲５五銀(56)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea31418>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea31260 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c80027d30 @drop_hand=nil, @move_hand=<△６七銀成(76)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c80027e48>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c80027df8 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c8002de88 @drop_hand=<▲５四歩打>, @move_hand=nil, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c8002e130>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c8002e018 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c8003e5f8 @drop_hand=nil, @move_hand=<△６二銀(53)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c8003e738>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c8003e670 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c80045790 @drop_hand=nil, @move_hand=<▲５六飛(58)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c80045858>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c80045808 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c80056c70 @drop_hand=nil, @move_hand=<△７七全(67)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c80056d38>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c80056cc0 @total_seconds=0, @used_seconds=0>>
# >> nil
# >> #<Bioshogi::HandLog:0x00007f8c8005dfc0 @drop_hand=nil, @move_hand=<▲７七桂(89)>, @candidate=nil, @place_same=true, @skill_set=#<Bioshogi::SkillSet:0x00007f8c8005e100>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c8005e010 @total_seconds=0, @used_seconds=0>>
# >> 29
# >> #<Bioshogi::HandLog:0x00007f8c7e27a210 @drop_hand=<△３四角打>, @move_hand=nil, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e27a2d8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e27a260 @total_seconds=0, @used_seconds=0>>
# >> 29
# >> #<Bioshogi::HandLog:0x00007f8c7e271d40 @drop_hand=nil, @move_hand=<▲６六飛(56)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e271e30>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e271de0 @total_seconds=0, @used_seconds=0>>
# >> 29
# >> #<Bioshogi::HandLog:0x00007f8c7e28a638 @drop_hand=<△５二歩打>, @move_hand=nil, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7e28a6d8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7e28a688 @total_seconds=0, @used_seconds=0>>
# >> 29
# >> #<Bioshogi::HandLog:0x00007f8c7ea53f90 @drop_hand=nil, @move_hand=<▲７九金(69)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea481b8>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea48078 @total_seconds=0, @used_seconds=0>>
# >> 29
# >> #<Bioshogi::HandLog:0x00007f8c7ea5ade0 @drop_hand=nil, @move_hand=<△８四飛(82)>, @candidate=nil, @place_same=false, @skill_set=#<Bioshogi::SkillSet:0x00007f8c7ea5af20>, @handicap=true, @personal_clock=#<Bioshogi::ChessClock::PersonalClock:0x00007f8c7ea5aea8 @total_seconds=0, @used_seconds=0>>
# >> 29
