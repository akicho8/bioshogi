require "#{__dir__}/setup"

Bioshogi::Assertion.assert(false)      rescue $! # => #<Bioshogi::MustNotHappen: assert failed: false>
Bioshogi::Assertion.assert_equal(0, 1) rescue $! # => #<Bioshogi::MustNotHappen: assert_equal failed: 0 != 1>
