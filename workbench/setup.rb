require "bundler/setup"
require "bioshogi"

include Bioshogi

require "pp"
require "active_support/core_ext/benchmark"
require "stackprof"
require "shellwords"

def identify(*args)
  puts `identify #{args.shelljoin}`
end

def chrome(*args)
  system "open -a 'Google Chrome' #{args.shelljoin}"
end

def preview(*args)
  system "open #{args.shelljoin}"
end
