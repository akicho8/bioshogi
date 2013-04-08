# -*- coding: utf-8 -*-
module Bushido
  class XtraPattern < Hash
    @list = []

    def self.list
      @list
    end

    def self.each(&block)
      @list.each(&block)
    end

    def self.store(objects)
      @list += Array.wrap(objects).collect{|e|new(e)}
    end

    def self.define(&block)
      store(block.call)
    end

    def initialize(obj)
      replace(obj)
    end
  end
end
