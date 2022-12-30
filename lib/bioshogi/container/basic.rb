# frozen-string-literal: true

module Bioshogi
  module Container
    class Basic
      include CoreMethods
      include PlayersMethods
      include SerializeMethods
      include ExecuteMethods
      include TestMethods
    end
  end
end
