#
# 静的盤面データ
#
module Bushido
  class Stock < Hash
    @list = []

    def self.store(objects)
      @list += Array.wrap(objects).collect{|e|new(e)}
    end

    def self.list
      @list
    end

    def self.reload_all
      @list.clear
      store StaticBoard
    end

    def initialize(obj)
      replace(obj)
    end

    def parsed_board
      @parsed_board ||= BaseFormat.board_parse(self[:board])
    end

    reload_all
  end
end
