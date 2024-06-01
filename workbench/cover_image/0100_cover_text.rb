require "../setup"

CoverImage.renderer(text: "なんとか　将棋大会\n☗先手 vs ☖後手\n2021-09-12\nabcdefghijklmnopqrstuvwxyz").display

s = "8th ほんわか将棋道場リレー大会1回戦
先手：かみおさ, ゆっきー, hidechan
後手：メロンパン, もるかー, ゆい
観戦：ねころび,きなこもち,金,さとり,ころっけ"
CoverImage.renderer(text: s, width: 1920, height: 1080).display
