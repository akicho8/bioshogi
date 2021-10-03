require "bundler/setup"
require "bioshogi"

include Bioshogi

require "pp"
require "active_support/core_ext/benchmark"
require "stackprof"
require "shellwords"

SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

def identify(*args)
  puts `identify #{args.shelljoin}`
end

def chrome(*args)
  system "open -a 'Google Chrome' #{args.shelljoin}"
end

def preview(*args)
  system "open #{args.shelljoin}"
end
