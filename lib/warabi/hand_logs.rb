# frozen-string-literal: true

module Warabi
  class HandLogs < SimpleDelegator
    def to_kif_a
      collect { |e| e.to_kif(with_location: false) }
    end

    def to_ki2_a
      collect { |e| e.to_ki2(with_location: true) }
    end
  end
end
