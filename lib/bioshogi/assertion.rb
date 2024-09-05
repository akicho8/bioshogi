# frozen-string-literal: true

module Bioshogi
  module Assertion
    extend self

    def assert(actual = nil, message = nil, &block)
      if block_given?
        actual = yield
      end
      unless actual
        message ||= "assert failed"
        raise MustNotHappen, "#{message}: #{actual.inspect}"
      end
    end

    def assert_equal(expected, actual, message = nil)
      if expected != actual
        message ||= "assert_equal failed"
        raise MustNotHappen, "#{message}: #{expected.inspect} != #{actual.inspect}"
      end
    end
  end
end
