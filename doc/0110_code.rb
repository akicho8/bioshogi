#+hidden: true
require "./setup"

#+title2: 機能

# - 各種棋譜フォーマットの読み書き
# - 各種棋譜フォーマットの相互変換
# - 対応フォーマット: kif, bod, ki2, csa, sfen
# - 棋譜から戦法名や囲い名を抽出する
# - 指定局面の最善手を返す

#+title2: 棋譜の読み取りと変換

info = Bioshogi::Parser.parse("76歩 34歩")
info.to_kif   # => "手合割：平手\n手数----指手---------消費時間--\n   1 ７六歩(77)\n   2 ３四歩(33)\n   3 投了\nまで2手で後手の勝ち\n"
info.to_sfen  # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
info.to_csa   # => "V2.2\n' 手合割:平手\nPI\n+\n+7776FU\n-3334FU\n%TORYO\n"
info.to_ki2   # => "手合割：平手\n\n▲７六歩 △３四歩\nまで2手で後手の勝ち\n"
