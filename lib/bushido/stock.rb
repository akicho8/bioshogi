# -*- coding: utf-8 -*-
#
# 静的盤面データ
#
module Bushido
  class Stock < Hash
    attr_reader :data

    @list = []

    def self.store(objects)
      @list += Array.wrap(objects).collect{|e|new(e)}
    end

    def self.list
      @list
    end

    def initialize(data)
      replace(data)
    end

    def parse_data
      return @parse_data if @parse_data
      @parse_data = BaseFormat.board_parse(self[:board])
    end

    store BoardLibs
  end

  # class Stock
  #   include Singleton
  #
  #   # class << self
  #   #   def each(&block)
  #   #     instance.stocks.each(&block)
  #   #   end
  #   # end
  #
  #   attr_reader :stocks
  #
  #   def initialize
  #     @stocks = []
  #   end
  #
  #   def store(objects)
  #     @stocks += Array.wrap(objects).collect{|e|Stock.new(e)}
  #   end
  #
  #   # def each(&block)
  #   #   instance.stocks.each(&block)
  #   # end
  #
  #   instance.store(BoardLibs)
  # end
end
