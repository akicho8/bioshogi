# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/vector_spec.rb" -*-
#
# 駒の移動ベクトル定義用
#
module Bushido
  class Vector < Array
    def reverse_sign
      x, y = self
      self.class[-x, -y]
    end
  end
end
