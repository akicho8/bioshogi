module Bioshogi
  concern :KakinokiBuilder do
    # 全角対応 ljust
    #
    #  mb_ljust("あ", 3)  # => "あ "
    #  mb_ljust("1", 3)   # => "1  "
    #  mb_ljust("123", 3) # => "123"
    #
    def mb_ljust(str, width)
      n = width - str.encode("EUC-JP").bytesize
      if n < 0
        n = 0
      end
      str + " " * n
    end
  end
end
