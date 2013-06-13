# -*- coding: utf-8 -*-
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

    def guguru_url
      Utils.guguru_url(self[:key])
    end

    reload_all
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
  #   instance.store(StaticBoard)
  # end
end
