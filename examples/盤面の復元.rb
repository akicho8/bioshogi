# -*- coding: utf-8 -*-
# 盤面の復元

require "bundler/setup"
require "bushido"
include Bushido

# frame = LiveFrame.basic_instance
# frame.piece_plot
# frame.execute("７六歩")
# frame.execute("３四歩")
# frame.execute("２二角成")
# puts frame

player = Player.basic_test(:init => "５九玉", :exec => "５八玉")
p player
memento = player.create_memento
player.restore_memento(memento)
p player
