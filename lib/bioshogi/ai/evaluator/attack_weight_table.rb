# frozen-string-literal: true

module Bioshogi
  module AI
    module Evaluator
      # http://www.yss-aya.com/book.html
      AttackWeightTable = {
        # 相手玉近くの自分の金銀の価値
        :attack => [
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # -8
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # -7
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # -6
          [  54,  53,  51,  51,  50,  50,  50,  50,  50], # -5
          [  70,  66,  62,  55,  53,  50,  50,  50,  50], # -4
          [  90,  85,  80,  68,  68,  60,  53,  50,  50], # -3
          [ 100,  97,  95,  85,  84,  71,  51,  50,  50], # -2
          [ 132, 132, 129, 102,  95,  71,  51,  50,  50], # -1
          [ 180, 145, 137, 115,  91,  75,  57,  50,  50], # 0
          [ 170, 165, 150, 121,  94,  78,  58,  52,  50], # 1
          [ 170, 160, 142, 114,  98,  80,  62,  55,  50], # 2
          [ 140, 130, 110, 100,  95,  75,  54,  50,  50], # 3
          [ 100,  99,  95,  87,  78,  69,  50,  50,  50], # 4
          [  80,  78,  72,  67,  55,  51,  50,  50,  50], # 5
          [  62,  60,  58,  52,  50,  50,  50,  50,  50], # 6
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # 7
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # 8
        ],
        # 自玉近くの自分の金銀の価値
        :defense => [
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # -8
          [  56,  52,  50,  50,  50,  50,  50,  50,  50], # -7
          [  64,  61,  55,  50,  50,  50,  50,  50,  50], # -6
          [  79,  77,  70,  65,  54,  51,  50,  50,  50], # -5
          [ 100,  99,  95,  87,  74,  58,  50,  50,  50], # -4
          [ 116, 117, 101,  95,  88,  67,  54,  50,  50], # -3
          [ 131, 129, 124, 114,  90,  71,  59,  51,  50], # -2
          [ 137, 138, 132, 116,  96,  76,  61,  53,  50], # -1
          [ 142, 142, 136, 118,  98,  79,  64,  52,  50], # 0
          [ 132, 132, 129, 109,  95,  75,  60,  51,  50], # 1
          [ 121, 120, 105,  97,  84,  66,  54,  50,  50], # 2
          [  95,  93,  89,  75,  68,  58,  51,  50,  50], # 3
          [  79,  76,  69,  60,  53,  50,  50,  50,  50], # 4
          [  64,  61,  55,  51,  50,  50,  50,  50,  50], # 5
          [  56,  52,  50,  50,  50,  50,  50,  50,  50], # 6
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # 7
          [  50,  50,  50,  50,  50,  50,  50,  50,  50], # 8
        ],
      }
    end
  end
end
