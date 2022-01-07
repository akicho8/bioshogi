require "../setup"
Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL x - 1 moves 2g2f\n3c3d") rescue $! # => #<Bioshogi::SyntaxDefact: 入力されたSFEN形式が不正確です。途中で改行を含めないでください : "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL x - 1 moves 2g2f\n3c3d">
Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b   1") rescue $! # => #<Bioshogi::SyntaxDefact: 入力されたSFEN形式が不正確です。2つ以上のスペースが含まれることは基本無いので持駒の部分などが欠けていないか確認してください : "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b   1">
