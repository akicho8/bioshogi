require "./setup"

puts Parser.parse("V2.2,P-51OU,P+53KI00GI,P-00AL,-,-5141OU,+0052GI", debug: true).to_csa
# >> 上手の持駒：飛二 角二 金三 銀三 桂四 香四 歩一八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ 金 ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 下手の持駒：銀
# >> 手数＝0 まで
# >>
# >> 上手番
# >>
# >> 上手の持駒：飛二 角二 金三 銀三 桂四 香四 歩一八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・v玉 ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ 金 ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 下手の持駒：銀
# >> 手数＝1 △４一玉(51) まで
# >>
# >> V2.2
# >> P1 *  *  *  * -OU *  *  *  *
# >> P2 *  *  *  *  *  *  *  *  *
# >> P3 *  *  *  * +KI *  *  *  *
# >> P4 *  *  *  *  *  *  *  *  *
# >> P5 *  *  *  *  *  *  *  *  *
# >> P6 *  *  *  *  *  *  *  *  *
# >> P7 *  *  *  *  *  *  *  *  *
# >> P8 *  *  *  *  *  *  *  *  *
# >> P9 *  *  *  *  *  *  *  *  *
# >> P+00GI
# >> P-00HI00HI00KA00KA00KI00KI00KI00GI00GI00GI00KE00KE00KE00KE00KY00KY00KY00KY00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU
# >> -
# >> -5141OU
# >> +0052GI
# >> %TORYO
