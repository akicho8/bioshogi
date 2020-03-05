# frozen-string-literal: true

module Bioshogi
  class HandLogs < SimpleDelegator
    def to_kif_a(options = {})
      options = {
        with_location: false,
      }.merge(options)

      collect { |e| e.to_kif(options) }
    end

    def to_ki2_a
      collect { |e| e.to_ki2(with_location: true) }
    end

    def to_kif_oneline
      collect { |e| e.to_kif(with_location: true) }.join(" ")
    end
  end
end
