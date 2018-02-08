require "bundler/setup"
require "warabi"
include Warabi

require "warabi/mediator_test_helper"
Mediator.include(MediatorTestHelper)

require "pp"
require "active_support/core_ext/benchmark"
