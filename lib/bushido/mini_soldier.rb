# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/shash_spec.rb" -*-
#
#  Utils.str_to_shash("４二竜") # => {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
#
module Bushido
  class MiniSoldier < Hash
    def to_s
      Utils.shash_to_s(self)
    end
  end
end
