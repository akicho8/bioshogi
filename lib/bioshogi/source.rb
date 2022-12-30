module Bioshogi
  class Source
    class << self
      def wrap(value)
        if value.kind_of? self
          return value
        end
        new(value)
      end
    end

    private_class_method :new

    def initialize(str)
      if str.respond_to?(:expand_path)
        str = str.expand_path
      end
      if str.respond_to?(:read)
        str = str.read
      end
      str = str.to_s.toutf8.rstrip + "\n"
      str = str.gsub(/\p{blank}*\R/, "\n") # バイナリだとここで死ぬ
      @value = str.freeze
    end

    def to_s
      @value
    end
  end
end
