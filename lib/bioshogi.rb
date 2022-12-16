require "active_support/logger"
require "active_support/configurable"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/class/attribute_accessors"  # for cattr_accessor
require "active_support/core_ext/module/attribute_accessors" # for mattr_accessor
require "active_support/core_ext/string"
require "active_support/tagged_logging"

require "active_support/dependencies/autoload"
require "active_support/core_ext/array/grouping" # for in_groups_of
require "active_support/core_ext/numeric"        # for 1.minute

require "pathname" # for toeuc
require "time"     # for Time.parse
require "kconv"    # for toeuc

require "table_format"
require "memory_record"
require "tree_support"

module Bioshogi
  ROOT_DIR   = "#{__dir__}/lib"
  ASSETS_DIR = "#{ROOT}/assets"

  include ActiveSupport::Configurable
  config_accessor(:skill_monitor_enable) { true }
  mattr_accessor(:run_counts) { Hash.new(0) }

  SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/bioshogi/logger.rb")
loader.ignore("#{__dir__}/bioshogi/vector.rb")
loader.ignore("#{__dir__}/bioshogi/errors.rb")
loader.ignore("#{__dir__}/bioshogi/contrib/**/*.rb")
loader.ignore("#{__dir__}/bioshogi/assets")
loader.ignore("#{__dir__}/bioshogi/cli.rb")
loader.ignore("#{__dir__}/bioshogi/cli")
loader.ignore("#{__dir__}/bioshogi/explain/{備考,囲い,戦型,手筋}")

# generator 系は development 専用のため
loader.do_not_eager_load("#{__dir__}/explain/*_generator")

# loader.log!
loader.setup

require "bioshogi/logger"
require "bioshogi/vector"
require "bioshogi/errors"

loader.eager_load
