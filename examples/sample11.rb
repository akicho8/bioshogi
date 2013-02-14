# -*- coding: utf-8 -*-
# エラーの再現用

require "bundler/setup"
require "bushido"
include Bushido

frame = LiveFrame.testcase3(:init => ["１五歩", "１三歩"], :exec => "１四歩")
a = Marshal.dump(frame)
frame = Marshal.load(a)
p frame.next_player
frame.execute("同歩")
p frame.prev_player.parsed_info.last_kif_pair
