module Bioshogi
  module Assertion
    extend self

    def assert(actual = nil, message = "assert failed", &block)
      if block_given?
        actual = yield
      end
      unless actual
        raise MustNotHappen, "#{message}: #{actual.inspect}"
      end
    end

    def assert_equal(expected, actual, message = "assert_equal failed")
      unless expected == actual
        raise MustNotHappen, "#{message}: #{expected.inspect} != #{actual.inspect}"
      end
    end
  end
end
